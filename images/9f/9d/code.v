module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    output reg [3:0] counter_out,
    output reg comp_out, // Output from comparator module
    output reg [1:0] pos  );// 2-bit output indicating the highest priority input bit.

    reg [3:0] count;
    reg [3:0] comp_val = 4'b1010; // Given value for comparator

    // Counter module
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end

    // Comparator module
    always @(posedge clk) begin
        if (count >= comp_val) begin
            comp_out <= 1'b1;
        end else begin
            comp_out <= 1'b0;
        end
    end

    // Priority encoder module
    always @(posedge clk) begin
        if (reset) begin
            pos <= 2'b00;
        end else if (comp_out) begin
            pos <= 2'b10;
        end else if (count[3]) begin
            pos <= 2'b01;
        end else begin
            pos <= 2'b00;
        end
    end

    // Output assignments
    assign counter_out = count;

endmodule