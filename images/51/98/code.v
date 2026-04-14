module mux2to1 (
    input sel,
    input [3:0] in0,
    input [3:0] in1,
    output reg [3:0] out);
    
    always @(*) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule