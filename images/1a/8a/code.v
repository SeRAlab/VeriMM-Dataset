module mux4to1 (
    input [7:0] data0,
    input [7:0] data1,
    input [7:0] data2,
    input [7:0] data3,
    input [1:0] sel,
    input clk,
    output reg [7:0] out
);
    reg [7:0] last_out;

    always @(posedge clk) begin
        if (sel == 2'b00) begin
            out <= last_out; // Forward last output
        end else begin
            case (sel)
                2'b01: out <= data1;
                2'b10: out <= data2;
                2'b11: out <= data3;
                default: out <= data0;
            endcase
        end
        last_out <= out; // Update last_out
    end
endmodule