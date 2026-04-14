module register8bit_sync_reset (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk) begin
        if (rst)
            data_out <= 8'b00000000;
        else if (load)
            data_out <= data_in;
    end

endmodule