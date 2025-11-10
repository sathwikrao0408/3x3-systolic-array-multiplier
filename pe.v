module pe(clk,reset,in_a,in_b,out_c);

 input wire reset,clk;
 input wire [1:0] in_a,in_b;
 output reg [4:0] out_c;
 always @(posedge clk) begin
    if(reset) 
      out_c=0;
    else 
      out_c=out_c+in_a*in_b; end 
      
endmodule
