module top_module(
    input clk,
    input reset,
    input [7:0] data_in_1,
    input [7:0] data_in_2,
    input control_signal,
    output reg ready_out,
    output reg [15:0] result_out
);reg [7:0] add_result;
reg [15:0] mult_result;

always @(posedge clk) begin
    if (reset) begin
        ready_out <= 0;
        result_out <= 0;
        add_result <= 0;
        mult_result <= 0;
    end else begin
        if (control_signal) begin
            // Addition operation
            add_result <= data_in_1 + data_in_2;
            result_out <= {8'b0, add_result};
        end else begin
            // Multiplication operation
            mult_result <= data_in_1 * data_in_2;
            result_out <= mult_result;
        end
        ready_out <= 1;
    end
end

endmodule