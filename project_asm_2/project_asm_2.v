module project_asm_2( 	(*chip_pin= "23"*) input wire clk,

							(*chip_pin= "25"*) input wire reset,
							(*chip_pin= "88"*) input wire i_ckey_1,
							(*chip_pin= "89"*) input wire i_ckey_2,
							(*chip_pin= "90"*) input wire i_ckey_3,
							(*chip_pin= "91"*) input wire i_ckey_4,
							
							(*chip_pin= "84"*) output wire o_led_1,
							(*chip_pin= "85"*) output wire o_led_2,
							(*chip_pin= "86"*) output wire o_led_3,
							(*chip_pin= "87"*) output wire o_led_4,
							
							(*chip_pin= "133"*) output wire o_dig_1,
							(*chip_pin= "135"*) output wire o_dig_2,
							(*chip_pin= "136"*) output wire o_dig_3,
							(*chip_pin= "137"*) output wire o_dig_4,
							
							(*chip_pin= "128"*) output wire o_seg_0,
							(*chip_pin= "121"*) output wire o_seg_1,
							(*chip_pin= "125"*) output wire o_seg_2,
							(*chip_pin= "129"*) output wire o_seg_3,
							(*chip_pin= "132"*) output wire o_seg_4,
							(*chip_pin= "126"*) output wire o_seg_5,
							(*chip_pin= "124"*) output wire o_seg_6,
							(*chip_pin= "127"*) output wire o_seg_7	);

reg [3:0] ckey;

assign ckey[0] = i_ckey_1;
assign ckey[1] = i_ckey_2;
assign ckey[2] = i_ckey_3;
assign ckey[3] = i_ckey_4;

assign o_led_1 = i_ckey_1;
assign o_led_2 = i_ckey_2;	
assign o_led_3 = i_ckey_3;	
assign o_led_4 = i_ckey_4;																						

reg [3:0] Anode_Activate;

assign o_dig_1 = Anode_Activate[0];
assign o_dig_2 = Anode_Activate[1];
assign o_dig_3 = Anode_Activate[2];
assign o_dig_4 = Anode_Activate[3];

reg [7:0] LED_out;

	 //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h

assign o_seg_0 = LED_out[0];
assign o_seg_1 = LED_out[1];
assign o_seg_2 = LED_out[2];
assign o_seg_3 = LED_out[3];
assign o_seg_4 = LED_out[4];
assign o_seg_5 = LED_out[5];
assign o_seg_6 = LED_out[6];
assign o_seg_7 = LED_out[7];

integer i;
integer j;

reg [3:0] cnt;
 

reg [7:0] number;
assign number = 8'b01111111;

reg [7:0] reg1;
reg [7:0] reg2;
assign reg2 = 8'b00001111;

reg [4:0] result1;            // First segments's value

reg [4:0] result2;            // Second segments's value

reg [4:0] result3;            // Third segments's value

reg [4:0] LED_BCD;            // Current segments's value (not used)

reg [19:0] refresh_counter;   // Segmens update counter

wire [1:0] LED_activating_counter;  // Segment activation counter


parameter zero   = 8'hC0;  //Value for zero
parameter one    = 8'hF9;  //Value for one
parameter two    = 8'hA4;  //Value for two
parameter three  = 8'hB0;  //Value for three
parameter four   = 8'h99;  //Value for four
parameter five   = 8'h92;  //Value for five
parameter six    = 8'h82;  //Value for six
parameter seven  = 8'hF8;  //Value for seven
parameter eight  = 8'h80;  //Value for eight
parameter nine   = 8'h90;  //Value for nine
parameter val_a   = 8'h88;  //Value for A
parameter val_b   = 8'h83;  //Value for B
parameter val_c   = 8'hC6;  //Value for C
parameter val_d   = 8'hA1;  //Value for D
parameter val_e   = 8'h86;  //Value for E
parameter val_f   = 8'h8E;  //Value for F

// Calculating cubic root of number

always@(*) begin : block_0

   case (ckey)
	4'b1111: begin
		reg [31:0] x;

		integer s;

		integer y;

		integer b;

		integer i;

		x = reg1;

		x = x * 1_000_000;

		 y = 0;

		 for (s=30;s>=0;s=s-3)

				begin : block_calc

				 y=y*2;

				 b = (3*y*(y+1)+1) << s;

				 if (x>=b)

				 begin : block_1

					  x = x-b;

					  y=y+1;

				 end

			end

		 result1 = y / 100;
		 result1[4] = 1;

		 result2 = (y % 100)/10;

		 result3 = y % 10;
	end
	4'b0111: begin // CLZ instruction
			integer result;
			result = 8;
			for (int i = 7; i >= 0; i--) begin
				 if (reg1[i] == 1) begin
					  result = 7 - i;
					  break;
				 end
			end
			result1 =  result / 100;

			result2 = (result % 100)/10;

			result3 =  result % 10;
	  end
	4'b1011: begin // CLZ instruction
			integer result;
			result = 0;
			for (int i = 0; i < 8; i++) begin
				 if (reg2[i] == 1) begin
					  result = result ^ (reg1 << i);
				 end
			end
			result1 =  result / 100;

			result2 = (result % 100)/10;

			result3 =  result % 10;
	  end
	4'b1110: begin
		result1 = reg1 / 100;

		result2 = (reg1 % 100)/10;

		result3 = reg1 % 10;
	end
	4'b1101: begin
		result1 = reg2 / 100;

		result2 = (reg2 % 100)/10;

		result3 = reg2 % 10;
	end
	endcase

end


always @(posedge clk)

    begin 

        if (!reset) begin
			reg1 <= reg1 + 1;
		  end

    end 
// Changing refresh_counter to update segments

always @(posedge clk)

    begin 

        refresh_counter <= refresh_counter + 1;

    end 

 

// Setting LED_activating_counter as 2 last bits of refresh_counter

// in order to update segments each 5.2 ms

assign LED_activating_counter = refresh_counter[19:18];

 

// Setting one segment activated accorfing to LED_activating_counter

always @(*)

    begin

        case(LED_activating_counter)

        2'b00: begin

            Anode_Activate = 4'b0111;

            LED_BCD = result1;

        end

        2'b01: begin

            Anode_Activate = 4'b1011;

            LED_BCD = result2;

               end

        2'b10: begin

            Anode_Activate = 4'b1101;

            LED_BCD = result3;

        end

        2'b11:  begin

            Anode_Activate = 4'b1110; 

            LED_BCD = 5'b01011;

        end

    endcase

end

 

// Setting value for activated segment

always @(*)

    begin

        case(LED_BCD)

            5'b00000: LED_out = zero; // "0" 

            5'b00001: LED_out = one; // "1" 

            5'b00010: LED_out = two; // "2" 

            5'b00011: LED_out = three; // "3" 

            5'b00100: LED_out = four; // "4" 

            5'b00101: LED_out = five; // "5" 

            5'b00110: LED_out = six; // "6" 

            5'b00111: LED_out = seven; // "7" 

            5'b01000: LED_out = eight; // "8" 

            5'b01001: LED_out = nine; // "9" 

            5'b01011: LED_out = 8'b11111111; // " " 

            5'b10000: LED_out = zero & 8'b01111111; // "0." 

            5'b10001: LED_out = one & 8'b01111111; // "1." 

            5'b10010: LED_out = two & 8'b01111111; // "2." 

            5'b10011: LED_out = three & 8'b01111111; // "3." 

            5'b10100: LED_out = four & 8'b01111111; // "4." 

            5'b10101: LED_out = five & 8'b01111111; // "5." 

            5'b10110: LED_out = six & 8'b01111111; // "6." 

            5'b10111: LED_out = seven & 8'b01111111; // "7." 

            5'b11000: LED_out = eight & 8'b01111111; // "8." 

            5'b11001: LED_out = nine & 8'b01111111; // "9." 

            default:  LED_out = 8'b11111111; // "8."

        endcase

    end

endmodule