module top_module(input [15:0] vec, output reg [4:0] count);integer i;
    integer result;
    always @(vec) begin
        result = 0;
        for (i=15; i>=0; i=i-1) begin
            if(vec[i] == 1'b1) begin
                result = result + 1;
            end
        end
        count = result;
    end
endmodule