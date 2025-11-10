module dff(clk,reset, a, y);

input wire clk,reset;
input wire [1:0] a;
output reg [1:0] y;
always@(posedge clk, negedge reset)
    if (reset)
        y <= 0;
    else 
        y<=a;
endmodule
