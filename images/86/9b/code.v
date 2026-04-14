module shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[6:0], 1'b0};
        end
    end

endmodule