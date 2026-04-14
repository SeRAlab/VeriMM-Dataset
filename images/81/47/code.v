module mux_4_to_1 (
    input en,
    input [1:0] sel,
    input [7:0] d0,
    input [7:0] d1,
    input [7:0] d2,
    input [7:0] d3,
    output reg [7:0] y
);

    always @(*) begin
        if (en) begin
            case (sel)
                2'b00: y = d0;
                2'b01: y = d1;
                2'b10: y = d2;
                2'b11: y = d3;
                default: y = 8'b00000000;
            endcase
        end else begin
            y = 8'b00000000;
        end
    end

endmodule