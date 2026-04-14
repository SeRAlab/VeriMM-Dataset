module register (
    input [3:0] data_in,
    input load,
    input clk,
    output reg [3:0] data_out
);

    always @(posedge clk) begin
        if (load)
            data_out <= data_in;
    end
endmodule