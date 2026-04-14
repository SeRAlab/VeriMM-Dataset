module reg_16bit_with_enable (
    input wire clk,
    input wire en,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    always @(posedge clk) begin
        if (en) begin
            data_out <= data_in;
        end
    end

endmodule