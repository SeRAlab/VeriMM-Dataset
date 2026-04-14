module mux_2_to_1 (
    input [4:0] data0,
    input [4:0] data1,
    input sel,
    output reg [4:0] out
);
    always @(*) begin
        if (sel) begin
            out = data1; // Forward data1 when sel is high
        end else begin
            out = 5'b00000; // Output default value when sel is low
        end
    end
endmodule