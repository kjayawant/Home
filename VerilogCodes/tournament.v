module tournament    (
predict52, 
predict2l, 
//predictorSelect,
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
output reg[4:0] globalhistory = 0;
reg [1:0] lookup[0:31];
integer k;
reg [1:0] predictinternal2l [1:0];
reg [1:0] predictinternal [1:0];
//----------Output Ports--------------
output reg[1:0] predict52;
output reg[1:0] predict2l;
reg[1:0] predictorSelect[1:0];
output reg[1:0] predict;
output integer mismatch = 0;

initial
begin
for (k = 0; k < 32; k = k + 1)
begin
    lookup[k] = 2'b00;
end
predictinternal2l[0]=0;
predictinternal2l[1]=0;
predictinternal[0]=0;
predictinternal[1]=0;
predictorSelect[0] = 2'b00;
predictorSelect[1] = 2'b00;
end

always @(posedge clk) begin
//----------5,2 global history---------------
globalhistory[4] = globalhistory[3];
globalhistory[3] = globalhistory[2];
globalhistory[2] = globalhistory[1];
globalhistory[1] = globalhistory[0];
globalhistory[0] = in;

if (reset == 1) begin
	predict52[1] = 0;
	predict52[0] = 0;
	mismatch = 0;
	end
else if (in == 1) begin
	predict52 = lookup[globalhistory];
	if (lookup[globalhistory] != 2'b11)  
	lookup[globalhistory] = lookup[globalhistory] + 1;
	end
else if (in == 0) begin
	predict52 = lookup[globalhistory];
	if (lookup[globalhistory] != 2'b00) 
	lookup[globalhistory] = lookup[globalhistory] - 1;
	end

//predict52 = predictinternal[branchnumber];

//-------------------2-bit local history-------
predict2l = predictinternal2l[branchnumber];

if (in == 1 & predictinternal2l[branchnumber] != 2'b11) 
		predictinternal2l[branchnumber] = predictinternal2l[branchnumber] + 1;

else if (in == 0 & predictinternal2l[branchnumber] != 2'b00)
		predictinternal2l[branchnumber] = predictinternal2l[branchnumber] - 1;
	
//---2 bit saturating Counter to select predictor------------
// 0-> 5,2
// 1-> 2bit local

	if (predictorSelect[branchnumber][1] == 1)
		predictinternal[branchnumber] = predict2l;
	else if (predictorSelect[branchnumber][1] == 0)
		predictinternal[branchnumber] = predict52;

	predict = predictinternal[branchnumber];

	if (in == predict[1] & predictorSelect[branchnumber] != 2'b00)
		predictorSelect[branchnumber] = predictorSelect[branchnumber] + 1;

	else if (in != predict[1] & predictorSelect[branchnumber] != 2'b11) 
		predictorSelect[branchnumber] = predictorSelect[branchnumber] - 1;
	
//----------------------------------------------
if (in != predict[1])
	mismatch = mismatch+1;
end

endmodule 