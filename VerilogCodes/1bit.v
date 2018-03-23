module onebit(
mismatch,
out,
in,
branchnumber,
reset,
clk,
);
//----------Output Ports--------------
output reg out;
output integer mismatch = 0;
//------------Input Ports-------------- 
input clk;
input reset;
input in;
input branchnumber;
//-------------Intermediate--------------
reg previousinput = 0;
//-------------Code Starts Here-------
always @(posedge clk)
begin
	if (reset == 1)
		out = 0;
	else begin
		out = previousinput ;
		previousinput = in;
	end
	
	if (in != out)
		mismatch = mismatch+1;
end

endmodule 
