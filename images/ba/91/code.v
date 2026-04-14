module top_module(
    input clk,
    input reset_n,
    input in_data,
    input in_valid,
    input in_ready,
    output reg out_data,
    output reg out_valid,
    output reg out_ready,
    output reg out_error
);reg [7:0] data_reg;
reg valid_reg;
reg ready_reg;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        data_reg <= 0;
        valid_reg <= 0;
        ready_reg <= 0;
        out_data <= 0;
        out_valid <= 0;
        out_ready <= 0;
        out_error <= 0;
    end else begin
        if (in_valid && out_ready) begin
            data_reg <= in_data;
            valid_reg <= 1;
            ready_reg <= 0;
            out_data <= in_data;
            out_valid <= 1;
            out_ready <= 0;
        end else if (valid_reg && in_ready) begin
            if (in_data != data_reg) begin
                out_error <= 1;
            end
            data_reg <= 0;
            valid_reg <= 0;
            ready_reg <= 1;
            out_data <= 0;
            out_valid <= 0;
            out_ready <= 1;
        end else begin
            data_reg <= 0;
            valid_reg <= 0;
            ready_reg <= 1;
            out_data <= 0;
            out_valid <= 0;
            out_ready <= 1;
        end
    end
end

endmodule