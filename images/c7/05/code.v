module xor_comp(
    input [7:0] A,
    input [7:0] B,
    input sel,
    output reg [7:0] C
    );

    always @(*) begin
        if(sel == 0)
            C = A ^ B;
        else
            C = ~A;
    end

endmodule