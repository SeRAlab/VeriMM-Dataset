module top_module(
    input clk,
    input reset,   // Synchronous active high reset
    input load,    // Synchronous load
    input [3:0] data_in,
    input [3:0] A,
    output [15:0] Y,
    output reg [3:0] count,
    output reg [3:0] final_output // Changed to reg to be able to assign in always block
);// 4-to-16 decoder
    wire [15:0] decoder_out;
    assign decoder_out = (A == 4'b0000) ? 16'b0000000000000001 :
                         (A == 4'b0001) ? 16'b0000000000000010 :
                         (A == 4'b0010) ? 16'b0000000000000100 :
                         (A == 4'b0011) ? 16'b0000000000001000 :
                         (A == 4'b0100) ? 16'b0000000000010000 :
                         (A == 4'b0101) ? 16'b0000000000100000 :
                         (A == 4'b0110) ? 16'b0000000001000000 :
                         (A == 4'b0111) ? 16'b0000000010000000 :
                         (A == 4'b1000) ? 16'b0000000100000000 :
                         (A == 4'b1001) ? 16'b0000001000000000 :
                         (A == 4'b1010) ? 16'b0000010000000000 :
                         (A == 4'b1011) ? 16'b0000100000000000 :
                         (A == 4'b1100) ? 16'b0001000000000000 :
                         (A == 4'b1101) ? 16'b0010000000000000 :
                         (A == 4'b1110) ? 16'b0100000000000000 :
                                         16'b1000000000000000;
    assign Y = ~decoder_out;

    // 4-bit binary counter
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= data_in;
        end else begin
            count <= count + 1;
        end
    end

    // Final output module
    always @(*) begin
        final_output = count + A;
    end

endmodule