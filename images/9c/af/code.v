module top_module (
    input [2:0] a,
    input en,
    output reg [7:0] y
);

    always @(*) begin
        if (en)
            y = 1 << a; // Decode input
        else
            y = 8'b00000000; // Outputs are zero when enable is low
    end

endmodule