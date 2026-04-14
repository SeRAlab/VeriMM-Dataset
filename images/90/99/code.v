module top_module(
    output reg [2:0] X,  // Change to reg type
    input  [3:0] A
);wire [2:0] decimal;

    assign decimal = A[3]*8 + A[2]*4 + A[1]*2 + A[0];

    always @(*) begin
        case (decimal)
            0: X = 3'b000;
            1: X = 3'b001;
            2: X = 3'b010;
            3: X = 3'b011;
            4: X = 3'b100;
            5: X = 3'b101;
            default: X = 3'b111;
        endcase
    end

endmodule