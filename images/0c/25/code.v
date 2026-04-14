module shift_register (
    input clk,
    input load,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load the input data
        end else begin
            data_out <= {1'b0, data_out[1]}; // Shift right
        end
    end
endmodule