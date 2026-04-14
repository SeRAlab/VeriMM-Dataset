module top_module(
    input [15:0] in,
    input [3:0] sel,
    input EN,
    input SH,
    input LD,
    output reg [15:0] Q
);reg [15:0] reg_Q;

always @(*) begin
    case (sel)
        4'b0000: reg_Q = in[0];
        4'b0001: reg_Q = in[1];
        4'b0010: reg_Q = in[2];
        4'b0011: reg_Q = in[3];
        4'b0100: reg_Q = in[4];
        4'b0101: reg_Q = in[5];
        4'b0110: reg_Q = in[6];
        4'b0111: reg_Q = in[7];
        4'b1000: reg_Q = in[8];
        4'b1001: reg_Q = in[9];
        4'b1010: reg_Q = in[10];
        4'b1011: reg_Q = in[11];
        4'b1100: reg_Q = in[12];
        4'b1101: reg_Q = in[13];
        4'b1110: reg_Q = in[14];
        4'b1111: reg_Q = in[15];
        default: reg_Q = 16'b0;
    endcase
end

always @(posedge SH) begin
    if (SH) begin
        Q <= {Q[14:0], 1'b0};
    end else begin
        Q <= {1'b0, Q[15:1]};
    end
end

always @(posedge LD) begin
    if (LD) begin
        Q <= reg_Q;
    end
end

always @(posedge EN) begin
    if (EN) begin
        Q <= reg_Q;
    end
end

endmodule