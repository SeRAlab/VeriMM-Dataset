module barrel_shifter (
    input [3:0] data,
    input [1:0] shamt,
    input dir,
    output reg [3:0] result
);
    always @(*) begin
        if (dir == 0) begin
            // Left shift
            result = data << shamt;
        end else begin
            // Right shift
            result = data >> shamt;
        end
    end
endmodule