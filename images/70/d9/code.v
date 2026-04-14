module top_module( input signal, clk, rst, output reg step );reg flag;
    always @(posedge clk) begin
        if(rst) begin
            step<=0;
            flag<=1;
        end
        else if(signal & flag) begin
            step<=1;
            flag<=0;
        end 
    end
endmodule