module flash_memory_cell (
    input clk,
    input reset,
    input [3:0] data_in,
    input shift_in,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else if (shift_in) begin
            data_out <= {data_out[2:0], data_in};
        end
    end
endmodule