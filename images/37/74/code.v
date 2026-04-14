module dvfs_controller(  
    input wire clk,  
    input wire rst,  
    input wire load,  
    output reg [1:0] freq_set,  // 00 -> 1 MHz, 01 -> 2 MHz  
    output reg [1:0] volt_set   // 00 -> 1.0 V, 01 -> 1.2 V  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            freq_set <= 2'b00;  
            volt_set <= 2'b00;  
        end else begin  
            case (load)  
                1'b0: begin  
                    freq_set <= 2'b00;  // 1 MHz  
                    volt_set <= 2'b00;  // 1.0 V  
                end  
                1'b1: begin  
                    freq_set <= 2'b01;  // 2 MHz  
                    volt_set <= 2'b01;  // 1.2 V  
                end  
            endcase  
        end  
    end  
endmodule