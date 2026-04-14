module top_module(
    input clk,
    input reset,
    input [7:0] in_signal,
    input [254:0] in_vector,
    output [7:0] edge_count,
    output [7:0] bit_count,
    output [7:0] output_sum
);// Edge detection module
    reg [7:0] edge_detect;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            edge_detect <= 8'b0;
        end else begin
            edge_detect <= {edge_detect[6:0], in_signal[7]} ^ in_signal;
        end
    end
    assign edge_count = edge_detect;

    // Population count module
    reg [7:0] pop_count;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pop_count <= 8'b0;
        end else begin
            pop_count <= {8{1'b0}} + in_vector;
        end
    end
    assign bit_count = pop_count;

    // Output sum module
    reg [7:0] sum;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            sum <= 8'b0;
        end else begin
            sum <= edge_detect + pop_count;
        end
    end
    assign output_sum = sum;

endmodule