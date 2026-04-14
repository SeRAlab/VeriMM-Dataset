module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid_in,
    output reg ready_out,
    output reg [3:0] seq_length_out
);reg [3:0] seq_length_current;
reg [3:0] seq_length_max;

always @(posedge clk) begin
    if (reset) begin
        seq_length_current <= 4'b0;
        seq_length_max <= 4'b0;
        ready_out <= 1'b0;
    end else begin
        if (valid_in) begin
            if (data_in[0]) begin
                seq_length_current <= seq_length_current + 1;
            end else begin
                seq_length_current <= 4'b0;
            end
            if (seq_length_current > seq_length_max) begin
                seq_length_max <= seq_length_current;
            end
            ready_out <= 1'b1;
        end else begin
            ready_out <= 1'b0;
        end
    end
end

assign seq_length_out = (valid_in) ? seq_length_max : 4'b0;

endmodule