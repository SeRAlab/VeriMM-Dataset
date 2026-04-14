module shift_register (
    input wire clk,
    input wire load,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load data
        end else begin
            data_out <= {1'b0, data_out[3:1]}; // Shift right and set LSB to 0
        end
    end
endmodule