module reset_controller #(parameter N = 5) (  
    input wire clk,  
    input wire reset,  
    output reg signal_out  
);  
    reg [2:0] counter; // 3-bit counter to count cycles  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            signal_out <= 0;  
            counter <= 0;  
        end else begin  
            if (counter < N - 1) begin  
                counter <= counter + 1;  
            end else begin  
                signal_out <= 1;  
            end  
        end  
    end  
endmodule