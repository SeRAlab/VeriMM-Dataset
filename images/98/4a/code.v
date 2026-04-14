module top_module(
    input [7:0] in,
    input clk,
    output reg [9:0] out
);// Odd parity bit generator
    reg [7:0] data_in;
    reg parity;
    always @(posedge clk) begin
        data_in <= in;
        parity <= ~(^data_in);
    end

    // Priority encoder
    wire [2:0] position;

    // Using a case statement to implement the priority encoder since $priority_encoder is not available
    assign position = (in == 8'b00000000) ? 3'b000 :
                      (in[7]) ? 3'b111 :
                      (in[6]) ? 3'b110 :
                      (in[5]) ? 3'b101 :
                      (in[4]) ? 3'b100 :
                      (in[3]) ? 3'b011 :
                      (in[2]) ? 3'b010 :
                      (in[1]) ? 3'b001 :
                      (in[0]) ? 3'b000 : 3'b000;

    // Final output
    always @(posedge clk) begin
        out[8] <= parity;
        out[7:5] <= position;
        out[4:0] <= 5'b00000;
    end

endmodule