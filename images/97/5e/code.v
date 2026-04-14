module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);reg [15:0] temp;
    reg [3:0] i;
    
    always @(*) begin
        temp = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (b[i] == 1) begin
                temp = temp + (a << i);
            end
        end
        result = temp;
    end
    
endmodule