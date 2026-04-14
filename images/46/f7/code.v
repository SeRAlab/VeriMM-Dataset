module top_module(a, b, result);input [7:0] a;
    input [7:0] b;
    output reg [15:0] result;
    integer i; // Declare i as an integer

    always @ (a, b)
    begin
        result = 0;
        for (i = 0; i < 8; i = i + 1)
        begin
            if (b[i] == 1)
            begin
                result = result + (a << i);
            end
        end
    end
endmodule