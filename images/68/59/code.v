module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg pattern_detected
);reg [3:0] zero_count;
reg [3:0] one_count;
reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        zero_count <= 0;
        one_count <= 0;
        shift_reg <= 0;
        pattern_detected <= 0;
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[6:0], data_in};

        // Update zero and one counts
        if (data_in == 8'h00) begin
            zero_count <= zero_count + 1;
        end else if (data_in == 8'hFF) begin
            one_count <= one_count + 1;
        end else begin
            zero_count <= 0;
            one_count <= 0;
        end

        // Check for pattern
        if (zero_count == 4 && one_count == 4 && shift_reg[7:4] == 4'h0) begin
            pattern_detected <= 1;
        end else begin
            pattern_detected <= 0;
        end
    end
end

endmodule