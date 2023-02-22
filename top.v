module top(
    input   clk   ,
    input   rst   ,
    input   [1:0] sw  ,
    output  [3:0] led
    );
    
    wire    clk_div ;
    
    counter counter_1(
    .clk    (clk_div),
    .rst    (rst),
    .in     (sw),
    .out    (led)
    );
    
    divider div_0(
    .clk    (clk),
    .rst    (rst),
    .clk_div    (clk_div)
    );
    
    
endmodule