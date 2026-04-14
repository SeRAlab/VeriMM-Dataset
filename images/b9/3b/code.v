module top_module(
    input clk,
    input reset,
    input [7:0] in,
    input [1:0] select,
    output reg [3:0] out
);reg [7:0] priority_enc;
reg [1:0] decoder_sel;

always @(posedge clk) begin
    if (reset) begin
        priority_enc <= 8'b0;
        decoder_sel <= 2'b0;
        out <= 4'b0;
    end else begin
        priority_enc <= in;
        decoder_sel <= select;
        case (decoder_sel)
            2'b00: out <= priority_enc[0] ? 1 : priority_enc[1] ? 2 : priority_enc[2] ? 3 : priority_enc[3] ? 4 : priority_enc[4] ? 5 : priority_enc[5] ? 6 : priority_enc[6] ? 7 : priority_enc[7] ? 8 : 0;
            2'b01: out <= priority_enc[0] ? 1 : priority_enc[1] ? 2 : priority_enc[2] ? 3 : priority_enc[3] ? 4 : priority_enc[4] ? 5 : priority_enc[5] ? 6 : priority_enc[6] ? 7 : priority_enc[7] ? 8 : 0;
            2'b10: out <= priority_enc[0] ? 1 : priority_enc[1] ? 2 : priority_enc[2] ? 3 : priority_enc[3] ? 4 : priority_enc[4] ? 5 : priority_enc[5] ? 6 : priority_enc[6] ? 7 : priority_enc[7] ? 8 : 0;
            2'b11: out <= priority_enc[0] ? 1 : priority_enc[1] ? 2 : priority_enc[2] ? 3 : priority_enc[3] ? 4 : priority_enc[4] ? 5 : priority_enc[5] ? 6 : priority_enc[6] ? 7 : priority_enc[7] ? 8 : 0;
        endcase
    end
end

endmodule