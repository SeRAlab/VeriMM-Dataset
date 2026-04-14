module top_module(
    input clk,
    input reset,
    input [1:0] select,
    input [3:0] sig_in,
    output reg sig_out
);always @(posedge clk) begin
    if (reset) begin
        sig_out <= 0;
    end else begin
        case (select)
            2'b00: sig_out <= sig_in[0];
            2'b01: sig_out <= sig_in[1];
            2'b10: sig_out <= sig_in[2];
            2'b11: sig_out <= sig_in[3];
        endcase
    end
end

endmodule