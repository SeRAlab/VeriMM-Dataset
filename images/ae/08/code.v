module top_module(input[31:0] ar, log, input select, output reg [31:0] result, output reg flag);always @ (*) begin
        if(select == 0) result = ar;
        else result = log;
        
        if(result == 32'b0) flag = 1;
        else flag = 0;
    end
endmodule