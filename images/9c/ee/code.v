module top_module(
    input [3:0] ain, 
    input [3:0] bin,
    output reg [4:0] sum
    );function [4:0] add_two_values;
        input [3:0] ain;
        input [3:0] bin;
        
        begin
            add_two_values[4] = 0;
            add_two_values = ain + bin;
        end
    endfunction
    
    always @(ain or bin) begin
        sum = add_two_values(ain, bin);
    end
endmodule