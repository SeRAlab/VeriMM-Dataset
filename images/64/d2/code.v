module top_module(
    input clk,
    input reset,
    input [7:0] in_signal,
    input [254:0] in_vector,
    output reg [7:0] edge_count,
    output reg [7:0] bit_count,
    output reg [7:0] output_diff
);reg [7:0] prev_signal;
reg [7:0] edge_count_reg;
reg [7:0] bit_count_reg;
reg [254:0] in_vector_reg;  // Use a register for in_vector

always @(posedge clk) begin
    if (reset) begin
        prev_signal <= 8'b0;
        edge_count_reg <= 8'b0;
        bit_count_reg <= 8'b0;
        output_diff <= 8'b0;
        in_vector_reg <= 255'b0;  // Initialize in_vector_reg
    end else begin
        if (in_signal > prev_signal) begin
            edge_count_reg <= edge_count_reg + 1;
        end
        prev_signal <= in_signal;
        
        // Update bit count with the first 8 bits of registered in_vector
        bit_count_reg <= {bit_count_reg[6:0], bit_count_reg[7]} + in_vector_reg[7:0]; // Properly index the in_vector_reg

        // Shift in_vector_reg to the right
        in_vector_reg <= {in_vector_reg[253:0], 1'b0};  // Assuming we want to shift right and insert 0 at MSB
        
        output_diff <= edge_count_reg - bit_count_reg;
    end
end

assign edge_count = edge_count_reg;
assign bit_count = bit_count_reg;

endmodule