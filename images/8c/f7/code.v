module top_module(
    input clk,
    input rst_n,
    input valid_in,
    input data_in,
    output reg valid_out,
    output reg [9:0] data_out
);// Shift register
    reg [2:0] shift_reg;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 3'b0;
        end else if (valid_in) begin
            shift_reg <= {shift_reg[1:0], data_in};
        end
    end

    // Accumulator
    reg [7:0] accumulator;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            accumulator <= 8'b0;
        end else if (valid_in) begin
            accumulator <= accumulator + shift_reg;
        end
    end

    // Output multiplexer
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else if (valid_in) begin
            valid_out <= 1'b1;
            data_out <= {accumulator, shift_reg};
        end else begin
            valid_out <= valid_out;
            data_out <= data_out;
        end
    end

endmodule