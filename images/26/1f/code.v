module temperature_comparator(
    input [3:0] tempA,
    input [3:0] tempB,
    output reg [1:0] result
);
    always @(*) begin
        if (tempA < tempB)
            result = 2'b00; // tempA < tempB
        else if (tempA == tempB)
            result = 2'b01; // tempA == tempB
        else
            result = 2'b10; // tempA > tempB
    end
endmodule