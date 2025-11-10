`timescale 1ns / 1ps

module test;
parameter data_size = 2;

reg clk;
reg reset;
reg [data_size-1:0] a1, a2, a3, b1, b2, b3;

wire [2*data_size:0] out_data;

top uut (.clk(clk),.reset(reset),.a1(a1), .a2(a2), .a3(a3),.b1(b1), .b2(b2), .b3(b3),.out_data(out_data) );

initial begin
    clk = 0;
    reset = 0;
    a1 = 0; a2 = 0; a3 = 0;
    b1 = 0; b2 = 0; b3 = 0;

    #5 reset = 1;
    #15 reset = 0;

    #10; a1 = 1; a2 = 2; a3 = 1; b1 = 1; b2 = 2; b3 = 3;
    #10; a1 = 3; a2 = 1; a3 = 2; b1 = 2; b2 = 1; b3 = 1;
    #10; a1 = 2; a2 = 2; a3 = 3; b1 = 3; b2 = 2; b3 = 3;
    #10; a1 = 0; a2 = 0; a3 = 0; b1 = 0; b2 = 0; b3 = 0;

    #200;
    $stop;
end

initial begin
    forever #5 clk = ~clk;
end

endmodule
