module register_8bit (
    input clk,
    input load,
    input clear,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk) begin
        if (clear)
            data_out <= 8'b00000000;
        else if (load)
            data_out <= data_in;
    end

endmodule