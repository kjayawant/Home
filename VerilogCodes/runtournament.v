module runtournament;

reg in,branch,clk,reset,temp;
wire [4:0] globalhistory;
wire [1:0] predict52;
wire [1:0] predict2l;
wire [1:0] predict;
wire [31:0] misses;
integer  file1,file2;
reg [7:0] separator,charinput, charbranch;

tournament mypredictor(.in(in), .branchnumber(branch), .clk(clk), .reset(reset), 
.predict52(predict52),.predict2l(predict2l),.predict(predict), .mismatch(misses),.globalhistory(globalhistory));

initial 
begin
	clk= 0;
	reset =0;
	in=0;
	branch=0;
end
initial
	#1 reset=1;
initial
	#2 reset=0;
always
	#5  clk =  ! clk;
initial begin
   
    file1 = $fopen("C:/Stuff/Spring 2017/585 Advanced Computer Architecture/Project/Verilog Codes/Input.txt","r");
    file2 = $fopen("C:/Stuff/Spring 2017/585 Advanced Computer Architecture/Project/Verilog Codes/Branch.txt","r");

end
always begin
    while (file1 != 0 && file1 != 0)
        begin
        temp = $fscanf(file1, "%c%c", separator, charinput);
        temp = $fscanf(file2, "%c%c", separator, charbranch);
        
	case (separator)
        
        ",": begin
            in     = charinput-48;
            branch = charbranch-48;
        end
        
	"x": begin
	   $display("__________________________\nTotal Misses\t: %d\n__________________________\n",misses);
	   #10;
           $stop;
        end
	default:
           $display("Unknown");

        endcase
           //$monitor("\t%b |\t%b |\t%d |\t%d",in,branch,predict,misses); 
	   #10;
        end 

end
endmodule 