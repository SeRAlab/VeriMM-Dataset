module top_module(
    input input_1,
    input [3:0] input_2,
    input [7:0] input_3,
    input [15:0] input_4
);wire [3:0] inverted_input_2;
    wire [15:0] processed_input_4;
    reg [3:0] modified_input_2; // Changed from wire to reg

    assign inverted_input_2 = ~input_2;
    assign processed_input_4 = (input_3 >= 128) ? (input_4 & 16'h00FF) : (input_4 | 16'hFF00);

    always @(*) begin
        if (input_1 == 1) begin
            modified_input_2 = {input_2[1:0], 2'b00}; // Use reg
        end else begin
            modified_input_2 = inverted_input_2; // Use reg
        end
    end

    // Update the output or further logic with modified_input_2 if necessary
    // This example assumes no output is needed

endmodule