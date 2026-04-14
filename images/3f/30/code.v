module divide_by_4(clk, reset, signal_in, signal_out);  
    input clk;  
    input reset;  
    input signal_in;  
    output reg signal_out;  

    reg [1:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 2'b00;  
            signal_out <= 1'b0;  
        end else begin  
            if (signal_in) begin  
                if (count == 2'b11) begin  
                    signal_out <= 1'b1;  
                end else begin  
                    count <= count + 1;  
                    signal_out <= 1'b0;  
                end  
            end else begin  
                count <= 2'b00;  
                signal_out <= 1'b0;  
            end  
        end  
    end  
endmodule