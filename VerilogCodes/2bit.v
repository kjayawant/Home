module twobit(
predict,  
mismatch,
in,
branchnumber,
reset,
clk,  // clock input
);
//-------------Input Ports---------------
input clk;
input reset;
input in;
input branchnumber;
//-------------Intermediate--------------
reg previousinput = 0;
//-------------Output Ports--------------
output reg [1:0]predict= 2'b00;
output integer mismatch=0;
//-------------Code Starts Here----------
always @(posedge clk) begin
	
	if (previousinput == 1 & predict != 2'b11) 
		predict = predict + 1;

	else if (previousinput == 0 & predict != 2'b00)
		predict = predict - 1;

	previousinput = in;

	if (in != predict[1])
		mismatch = mismatch+1;
end
endmodule 