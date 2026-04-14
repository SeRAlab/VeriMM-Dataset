module top_module(
    input clk,
    input reset,
    input [254:0] in,
    input [31:0] in2,
    output [15:0] out
);// First module - count number of '1's in input vector
    reg [7:0] count;
    reg [254:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b0;
            shift_reg <= 255'b0;
        end else begin
            shift_reg <= {shift_reg[253:0], in};
            if (shift_reg[254]) begin
                count <= count + 1;
            end
        end
    end

    // Second module - capture rising edges and hold output high until next rising edge
    reg [31:0] prev_in2;
    reg [31:0] edge_capture;
    always @(posedge clk) begin
        if (reset) begin
            prev_in2 <= 32'b0;
            edge_capture <= 32'b0;
        end else begin
            edge_capture <= (in2 ^ prev_in2) & in2;
            prev_in2 <= in2;
        end
    end

    // Functional module - sum the counts from the two modules
    assign out = count + $countones(edge_capture);

endmodule