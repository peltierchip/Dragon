`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:08:06 11/27/2017 
// Design Name: 
// Module Name:    randomGrid 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module randomGrid(pixel_clk, rand_X, rand_Y);
	input pixel_clk;
	output reg [6:0] rand_X;
	output reg [6:0] rand_Y;
	
	always@(posedge pixel_clk)
	begin
		rand_X <= ((rand_X + 3) % 78) + 1;
		rand_Y <= ((rand_Y + 5) % 58) + 1;
	end

endmodule
