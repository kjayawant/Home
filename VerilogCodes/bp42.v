module bp42    (
predict,  
mismatch,
globalhistory,
in,
branchnumber,
reset,
clk,  // clock input
);
//------------Input Ports-------------- 
input clk;
input in;
input branchnumber; 
input reset;
//------------Inermediate--------------
output reg[3:0] globalhistory = 0;
reg [1:0] lookup[0:15];
integer k;
//----------Output Ports--------------
output reg[1:0] predict;
output integer mismatch = 0;

initial
begin
for (k = 0; k < 16; k = k + 1)
begin
    lookup[k] = 2'b00;
end
predict[0]=0;
predict[1]=0;
end

always @(posedge clk) begin

	globalhistory[3] = globalhistory[2];
	globalhistory[2] = globalhistory[1];
	globalhistory[1] = globalhistory[0];
	globalhistory[0] = in;

if (reset == 1) begin
	predict[1] = 0;
	predict[0] = 0;
	mismatch = 0;
	end
else if (in == 1) begin 
	predict = lookup[globalhistory];
	if (lookup[globalhistory] != 2'b11)
	lookup[globalhistory] = lookup[globalhistory] + 1;
	end
else if (in == 0) begin
	predict = lookup[globalhistory];
	if (lookup[globalhistory] != 2'b00)
	lookup[globalhistory] = lookup[globalhistory] - 1;
	end
	
if (in != predict[1])
	mismatch = mismatch+1;
end

endmodule 