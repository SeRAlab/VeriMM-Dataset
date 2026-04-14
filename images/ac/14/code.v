module register_8bit (
    input clk,
    input load,
    input clear,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end
    end
endmodule