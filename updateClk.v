`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:59 11/27/2017 
// Design Name: 
// Module Name:    updateClk 
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
module updateClk(pixel_clk, update);
	input pixel_clk;
	output reg update;
	reg[21:0] count;
	
	always@(posedge pixel_clk)
	begin
		if(count == 1777777) begin
			update <= 1'b1;
			count <= 22'b0;
		end
		else begin
			update <= 1'b0;
			count <=  count + 1'b1;
		end
	end

endmodule
