module reset_controller(  
    input wire clk,  
    input wire reset_n,  
    output reg reset_out  
);  
    reg [3:0] count; // 4-bit counter for 10 cycles  

    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            count <= 0;  
            reset_out <= 1; // Assert reset_out high  
        end else begin  
            if (count < 10) begin  
                count <= count + 1;  
            end else begin  
                reset_out <= 0; // Deassert after 10 cycles  
            end  
        end  
    end  
endmodule