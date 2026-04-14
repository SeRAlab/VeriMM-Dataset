module top_module(
    input [7:0] data_in,
    input [2:0] shift_amt,
    input shift_dir,
    input reset,
    output reg [7:0] data_out
);always @(*) begin
    if (reset) begin
        data_out <= 0;
    end else begin
        if (shift_dir) begin
            // Perform left shift if shift_dir is high
            data_out <= data_in << shift_amt; // Left shift
        end else begin
            // Perform right shift if shift_dir is low
            data_out <= data_in >> shift_amt; // Right shift
        end
    end
end

endmodule