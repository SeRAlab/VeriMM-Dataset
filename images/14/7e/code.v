module mux4to1 (
    input [7:0] data0,
    input [7:0] data1,
    input [7:0] data2,
    input [7:0] data3,
    input sel0,
    input sel1,
    output reg [7:0] out
);
    reg [7:0] previous_out;

    always @(*) begin
        case ({sel1, sel0})
            2'b00: previous_out = data0;
            2'b01: previous_out = data1;
            2'b10: previous_out = data2;
            2'b11: previous_out = data3;
            default: previous_out = 8'bx;
        endcase

        if (previous_out == out) begin
            out = out; // Forwarding the output
        end else begin
            out = previous_out; // Change output
        end
    end
endmodule