module top(clk, reset, a1, a2, a3, b1, b2, b3, out_data);

input wire clk, reset;
input wire [1:0] a1, a2, a3, b1, b2, b3;
output reg [4:0] out_data;  

wire [1:0] a12, a23, a45, a56, a78, a89;
wire [1:0] b14, b25, b36, b47, b58, b69;
wire [1:0] a_2, b_2, a_3, a__3, b_3, b__3;

wire [4:0] c [0:8];  
reg  [4:0] buffer [0:8];  
reg  [3:0] index;        

dff df1 (.clk(clk), .reset(reset), .a(a2), .y(a_2));
dff df2 (.clk(clk), .reset(reset), .a(b2), .y(b_2));
dff df3 (.clk(clk), .reset(reset), .a(a3), .y(a_3));
dff df4 (.clk(clk), .reset(reset), .a(a_3), .y(a__3));
dff df5 (.clk(clk), .reset(reset), .a(b3), .y(b_3));
dff df6 (.clk(clk), .reset(reset), .a(b_3), .y(b__3));

pe pe1 (.clk(clk), .reset(reset), .in_a(a1), .in_b(b1), .out_c(c[0]));
dff f1 (.clk(clk), .reset(reset), .a(a1), .y(a12));
pe pe2 (.clk(clk), .reset(reset), .in_a(a12), .in_b(b_2), .out_c(c[1]));
dff f2 (.clk(clk), .reset(reset), .a(a12), .y(a23));
pe pe3 (.clk(clk), .reset(reset), .in_a(a23), .in_b(b__3), .out_c(c[2]));
dff f3 (.clk(clk), .reset(reset), .a(b1), .y(b14));
pe pe4 (.clk(clk), .reset(reset), .in_a(a_2), .in_b(b14), .out_c(c[3]));
dff f4 (.clk(clk), .reset(reset), .a(a_2), .y(a45));
dff f5 (.clk(clk), .reset(reset), .a(b_2), .y(b25));
pe pe5 (.clk(clk), .reset(reset), .in_a(a45), .in_b(b25), .out_c(c[4]));
dff f6 (.clk(clk), .reset(reset), .a(a45), .y(a56));
dff f7 (.clk(clk), .reset(reset), .a(b__3), .y(b36));
pe pe6 (.clk(clk), .reset(reset), .in_a(a56), .in_b(b36), .out_c(c[5]));
dff f8 (.clk(clk), .reset(reset), .a(b14), .y(b47));
pe pe7 (.clk(clk), .reset(reset), .in_a(a__3), .in_b(b47), .out_c(c[6]));
dff f9 (.clk(clk), .reset(reset), .a(a__3), .y(a78));
dff f10 (.clk(clk), .reset(reset), .a(b25), .y(b58));
pe pe8 (.clk(clk), .reset(reset), .in_a(a78), .in_b(b58), .out_c(c[7]));
dff f11 (.clk(clk), .reset(reset), .a(a78), .y(a89));
dff f12 (.clk(clk), .reset(reset), .a(b36), .y(b69));
pe pe9 (.clk(clk), .reset(reset), .in_a(a89), .in_b(b69), .out_c(c[8]));

reg [2:0] state;
localparam idle = 0, load = 1, dat_out = 2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        index <= 0;
        state <= idle;
        out_data <= 0; end
    else begin
        case (state)
            idle: begin
                index <= 0;
                state <= load; end
            load: begin
                buffer[0] <= c[0];
                buffer[1] <= c[1];
                buffer[2] <= c[2];
                buffer[3] <= c[3];
                buffer[4] <= c[4];
                buffer[5] <= c[5];
                buffer[6] <= c[6];
                buffer[7] <= c[7];
                buffer[8] <= c[8];
                state <= dat_out; end
            dat_out: begin
                out_data <= buffer[index];
                if (index == 8)
                    state <= idle;
                else
                    index <= index + 1; end
        endcase
    end
end
endmodule
