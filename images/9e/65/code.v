module top_module(
    input [15:0] A,
    input [3:0] S,
    input C,
    output reg [15:0] B
);reg [15:0] temp1, temp2, temp3, temp4;

always @ (posedge C) begin
    temp1 <= A;
end

always @ (posedge C) begin
    temp2 <= temp1 << S;
end

always @ (posedge C) begin
    temp3 <= temp1 >> S;
end

always @ (posedge C) begin
    if (C == 0) begin
        B <= temp2;
    end else begin
        B <= temp3;
    end
end

endmodule