module pipo_shift_register (
    input clk,
    input load_en,
    input shift_en,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (load_en) begin
            data_out <= data_in; // Load data
        end else if (shift_en) begin
            data_out <= {1'b0, data_out[7:1]}; // Shift right
        end
    end
endmodule