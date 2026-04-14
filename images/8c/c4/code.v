module top_module(
    input clk,
    input rst,
    input en,
    input ld,
    input signed [31:0] in,
    input [3:0] load_data,
    output [35:0] out
);// Absolute value module
    wire [31:0] abs_val;
    assign abs_val = (in < 0) ? -in : in;

    // Binary counter module
    reg [3:0] counter;
    always @(posedge clk) begin
        if (rst) begin
            counter <= 4'b0000;
        end else if (en) begin
            counter <= counter + 1;
        end else if (ld) begin
            counter <= load_data;
        end
    end

    // Output module
    assign out = abs_val + {32'b0, counter};

endmodule