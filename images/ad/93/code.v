module shift_register_8bit (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [7:0] data_in,
    input wire shift_in,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[6:0], shift_in};
        end
    end

endmodule