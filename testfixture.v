`timescale 1ns / 100ps
`define CYCLE 10
`define GOLDEN "./golden.txt"
`define End_CYCLE 5000
module testfixture;  

reg clk, rst;
reg [1:0] in;
wire [3:0] out;

reg [6:0] number;
reg [6:0] error;

counter counter(.clk(clk),
				.rst(rst),
				.in(in),
				.out(out));

reg [3:0] golden_mem [0:99];
reg [3:0] correct;

initial begin
	$readmemh(`GOLDEN,golden_mem);
	clk = 1'b0;
	rst = 1'b1;
	in = 2'd1;
	number = 0;
	error = 0;
	#(`CYCLE*1.2) rst = 1'b0;
end

/*initial begin
	$fsdbDumpfile("counter.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA();
end*/

always #(`CYCLE/2) clk = ~clk;

initial begin
    #(32*`CYCLE) in = 2'd2;
    
    #(17*`CYCLE) in = 2'd3;
    
    #(12*`CYCLE) in = 2'd1;
    
    #(7*`CYCLE) in = 2'd3;
    
    #(6*`CYCLE) in = 2'd2;
    
    #(6*`CYCLE) in = 2'd3;
    
    #(12*`CYCLE) in = 2'd1;
    
    #(10*`CYCLE);
	
end

initial begin
	#(`End_CYCLE);
	$display("-----------------------------------------------------\n");
	$display("Error!!! There is something wrong with your code ...!\n");
 	$display("------------The test result is .....FAIL ------------\n");
 	$display("-----------------------------------------------------\n");
 	$finish;
end

always @(negedge clk)begin
	if(~rst)begin
		correct = golden_mem[number];
		if(correct == out)begin
			$display("%d data is correct",number);
			number = number + 1;
		end
		else if(correct != out)begin
			$display("%d data is error, wrong: %d , correct: %d",number,out,correct);
			error = error + 1;
			number = number + 1;
		end
		else if(number == 7'd100)begin
			if(error == 0)begin
				$display("-------------------   counter check successfully   -------------------");
                $display("            $$              ");
                $display("           $  $");
                $display("           $  $");
                $display("          $   $");
                $display("         $    $");
                $display("$$$$$$$$$     $$$$$$$$");
                $display("$$$$$$$              $");
                $display("$$$$$$$              $");
                $display("$$$$$$$              $");
                $display("$$$$$$$              $");
                $display("$$$$$$$              $");
                $display("$$$$$$$$$$$$         $$");
                $display("$$$$$      $$$$$$$$$$");
				$finish ;
			end
			else begin
				$display("-------------------   There are %d errors   -------------------", error);
				$finish ;
			end
		end
	end
end

endmodule
