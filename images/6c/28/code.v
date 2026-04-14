module top_module(
    input clk,           // Added the clk input
    input [2:0] A,
    output reg [6:0] SEG
);reg [6:0] SEG_pipe1;
reg [6:0] SEG_pipe2;

always @(*) begin
    case(A)
        3'b000: SEG_pipe1 = 7'b1000000;
        3'b001: SEG_pipe1 = 7'b1111001;
        3'b010: SEG_pipe1 = 7'b0100100;
        3'b011: SEG_pipe1 = 7'b0110000;
        3'b100: SEG_pipe1 = 7'b0011001;
        3'b101: SEG_pipe1 = 7'b0010010;
        3'b110: SEG_pipe1 = 7'b0000010;
        3'b111: SEG_pipe1 = 7'b1111000;
        default: SEG_pipe1 = 7'b0000000; // Added default case for robustness
    endcase
end

always @(posedge clk) begin
    SEG_pipe2 <= SEG_pipe1;
end

always @(posedge clk) begin
    SEG <= SEG_pipe2;
end

endmodule