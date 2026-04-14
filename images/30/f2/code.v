module ShiftRegister (
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load new data
        end else begin
            data_out <= {1'b0, data_out[7:1]}; // Shift right
        end
    end
endmodule