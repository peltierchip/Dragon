`timescale 1ns / 1ps
// Group 4 DSL Lab 5 Innovative
module Snake(
	 input clk_100mhz,
    input [7:0] switch,
	 
    input btn_up,       // buttons, depress = high
    input btn_enter,
    input btn_left,
    input btn_down,
    input btn_right,
	 
    output [7:0] led,   // 1 turns on leds
	 
    output reg [2:0] vgared,
    output reg [2:0] vgagreen,
    output reg [2:1] vgablue,
    output hsync,
    output vsync
	 
    );

//////////////////////////////////////////////////////////////////
// dcm_all is a general purpose digital clock manager. It is used
// to create clocks at desired frequncies and phases.
//
   wire clk_25mhz;
	wire clk_100mhz_buf;  // 100mhz buffered clock, not used
		
   dcm_all_v2 #(.DCM_DIVIDE(8), .DCM_MULTIPLY(2))
     	my_clocks(
				.CLK(clk_100mhz),
				.CLKSYS(clk_100mhz_buf),
//				.CLK25(CLK25),
				.CLK_out(clk_25mhz) // 25mhz clock
	);
//
//////////////////////////////////////////////////////////////////

   wire pixel_clk = clk_25mhz;  // clock for 1024 x 768 60hz resolution  

   assign led = switch;  // provide feedback
	
	parameter [6:0] SIZE_INCREASE = 4;
 
	wire [9:0] xCount;
   wire [9:0]  yCount;
	wire [6:0] rand_X;
	wire [6:0] rand_Y;
	reg [6:0] size;
	reg [6:0] pearX = 40;
	reg [6:0] pearY = 10;
	wire display;
	wire R;
	wire G;
	wire B;
	reg game_over;
	reg pear, border;
	reg [6:0] dragonX[0:127];
	reg [6:0] dragonY[0:127];
	reg [127:0] dragonBody;
	wire update;
	reg [3:0] direction;
	
	integer count;
	
	debounce db_up(1'b0, pixel_clk, btn_up, up);
	debounce db_down(1'b0, pixel_clk, btn_down, down);
	debounce db_left(1'b0, pixel_clk, btn_left, left);
	debounce db_right(1'b0, pixel_clk, btn_right, right);
	debounce db_enter(1'b0, pixel_clk, btn_enter, enter);
	
	assign start = switch[7];
	
	VGA_gen gen1(pixel_clk, xCount, yCount, display, hsync, vsync);
	randomGrid rand1(pixel_clk, rand_X, rand_Y);
	updateClk update_clk(pixel_clk, update);
	
	always@(posedge pixel_clk) begin
		if (~start) begin
		dragonX[0] <= 40;
		dragonY[0] <= 30;
		for (count = 1; count < 128; count = count + 1)
			begin
				dragonX[count] <= 127;
				dragonY[count] <= 127;
			end
		size <= 1;
		game_over <= 0;
		end else if (~game_over) begin
			if (update) begin
				for (count = 1; count < 128; count = count + 1)
				begin
					if (size > count)
					begin
						dragonX[count] <= dragonX[count - 1];
						dragonY[count] <= dragonY[count - 1];
					end
				end
			// DIRECTION
			case(direction)
				4'b0001: dragonY[0] <= (dragonY[0] - 1);
				4'b0010: dragonY[0] <= (dragonY[0] + 1);
				4'b0100: dragonX[0] <= (dragonX[0] - 1);
				4'b1000: dragonX[0] <= (dragonX[0] + 1);
			endcase
				
			end else begin
				// Detect if hit pear
				if ((dragonX[0] == pearX) && (dragonY[0] == pearY)) begin
					pearX <= rand_X;
					pearY <= rand_Y;
					if (size < 128 - SIZE_INCREASE)
						size <= size + SIZE_INCREASE;
				end
				
				// Detect if hit border (Level 2)
				else if (switch[0] && ((dragonX[0] == 0) || (dragonX[0] == 79) || (dragonY[0] == 0) || (dragonY[0] == 59) || ((dragonX[0] == 10) && (dragonY[0] >= 10 && dragonY[0] <= 20)) || ((dragonX[0] == 69) && (dragonY[0] >= 39 && dragonY[0] <= 49)) || ((dragonY[0] == 10) && (dragonX[0] >= 10 && dragonX[0] <= 20)) || ((dragonY[0] == 49) && (dragonX[0] >= 59 && dragonX[0] <= 69))))
					game_over <= 1'b1;
				// Detect if hit border (Level 1)
				else if (switch[1] && ((dragonX[0] == 0) || (dragonX[0] == 79) || (dragonY[0] == 0) || (dragonY[0] == 59) ||((dragonY[0] == 20) && (dragonX[0] >= 10 && dragonX[0] <= 69)) || ((dragonY[0] ==40 ) && (dragonX[0] >= 10 && dragonX[0] <= 69))))
					game_over <= 1'b1;
				else if ((dragonX[0] == 0) || (dragonX[0] == 79) || (dragonY[0] == 0) || (dragonY[0] == 59))
					game_over <= 1'b1;
				//Level 3
				else if (switch[2] && ((dragonX[0] == 0) || (dragonX[0] == 79) || (dragonY[0] == 0) || (dragonY[0] == 59) || ((dragonX[0] == 39) && (dragonY[0] >= 0 && dragonY[0] <=10)) || ((dragonX[0] == 39) && (dragonY[0] >= 49 &&  dragonY[0]<=59))))
				   game_over <= 1'b1;
				// Detect if hit body
				else if (|dragonBody[127:1] && dragonBody[0])
					game_over <= 1'b1;
				end
			end
		end
		
	always@(posedge pixel_clk)
	begin
		if (up)
			direction <= 4'b0001;
		else if (down)
			direction <= 4'b0010;
		else if (left)
			direction <= 4'b0100;
		else if (right)
			direction <= 4'b1000;
	end
	
	// Border
	always@(posedge pixel_clk)
	begin
		if (switch[0])
		border <= ((xCount[9:3] == 0) || (xCount[9:3] == 79) || (yCount[9:3] == 0) || (yCount[9:3] == 59) || ((xCount[9:3] == 10) && (yCount[9:3] >= 10 && yCount[9:3] <= 20)) || ((xCount[9:3] == 69) && (yCount[9:3] >= 39 && yCount[9:3] <= 49)) || ((yCount[9:3] == 10) && (xCount[9:3] >= 10 && xCount[9:3] <= 20)) || ((yCount[9:3] == 49) && (xCount[9:3] >= 59 && xCount[9:3] <= 69)));
		else if (switch[1])
		border <= ((xCount[9:3] == 0) || (xCount[9:3] == 79) || (yCount[9:3] == 0) || (yCount[9:3] == 59) || ((yCount[9:3] == 20) && (xCount[9:3] >= 10 && xCount[9:3] <= 69)) || ((yCount[9:3] ==40 ) && (xCount[9:3] >= 10 && xCount[9:3] <= 69)));
		else if (switch[2])
		border <= ((xCount[9:3] == 0) || (xCount[9:3] == 79) || (yCount[9:3] == 0) || (yCount[9:3] == 59) || ((xCount[9:3] == 39) && (yCount[9:3] >= 0 && yCount[9:3] <=10)) || ((xCount[9:3] == 39) && (yCount[9:3] >= 49 && yCount[9:3] <=59)));
		else
		border <= ((xCount[9:3] == 0) || (xCount[9:3] == 79) || (yCount[9:3] == 0) || (yCount[9:3] == 59));
	end
	
	// Pear
	always@(posedge pixel_clk)
	begin
		pear <= ((xCount[9:3] == pearX) && (yCount[9:3] == pearY));
	end
	
	// Dragon body or head
	always@(posedge pixel_clk)
	begin
		for (count = 0; count < 128; count = count + 1)
			dragonBody[count] <= (xCount[9:3] == dragonX[count]) & (yCount[9:3] == dragonY[count]);
	end
	
	// Display
	assign R = (display && (pear || game_over));
	assign G = (display && (|dragonBody && ~game_over));
	assign B = (display && (border && ~game_over));
	
	always@(posedge pixel_clk)
	begin
		vgared   = {3{R}};
		vgagreen = {3{G}};
		vgablue  = {2{B}};
	end


endmodule







