module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );reg [99:0] sum_reg;
    reg cout_reg;
    integer i;

    always @(*) begin
        sum_reg[0] = a[0] ^ b[0] ^ cin;
        cout_reg = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
        for (i = 1; i < 100; i = i + 1) begin
            sum_reg[i] = a[i] ^ b[i] ^ sum_reg[i-1];
            cout_reg = (a[i] & b[i]) | (a[i] & sum_reg[i-1]) | (b[i] & sum_reg[i-1]);
        end
    end

    assign sum = sum_reg;
    assign cout = cout_reg;

endmodule