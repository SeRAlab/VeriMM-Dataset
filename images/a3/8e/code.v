module load_clear_register(
    input clk,
    input rst_n,
    input load,
    input clear,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 8'b00000000;
        end else if (clear) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end
    end
endmodule