module top_module(
    
    input wire [3:0] n,
    output reg [3:0] correct,
    output reg error
    );always@(n)
        begin
            if(n > 4'b1100)
                begin
                    error <= 1;
                    correct <= 0;
                end
            else
                begin
                    error <= 0;
                    correct <= n;
                end
        end       
endmodule