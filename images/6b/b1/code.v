module top_module(
    input [31:0] n,
    output reg [31:0] fact
);always @(*) begin
        case(n)
            0: fact = 1;
            1: fact = 1;
            2: fact = 2;
            3: fact = 6;
            4: fact = 24;
            5: fact = 120;
            6: fact = 720;
            7: fact = 5040;
            8: fact = 40320;
            9: fact = 362880;
            10: fact = 3628800;
            11: fact = 39916800;
            12: fact = 479001600;
            default: fact = 0;
        endcase
    end

endmodule