module bus_controller (
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] Max_Out,
    output reg Valid
);

always @(*) begin
    if (A > B) begin
        Max_Out = A;
        Valid = 1;
    end else begin
        Max_Out = B;
        Valid = 1;
    end
end
endmodule