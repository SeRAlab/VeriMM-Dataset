module top_module(
    input [7:0] A,
    input [7:0] B,
    input add,
    input sub,
    output [7:0] Z
);reg [7:0] temp;

    always @(*) begin
        if (add) begin
            temp = A + B;
        end
        else if (sub) begin
            temp = A - B;
        end
        else begin
            temp = 8'b0;
        end
    end

    assign Z = temp;

endmodule