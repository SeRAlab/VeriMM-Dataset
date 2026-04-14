module dvfs_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg [3:0] frequency,  // 4-bit frequency level  
    output reg [3:0] voltage     // 4-bit voltage level  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency <= 4'b0000;  
            voltage <= 4'b0000;  
        end else begin  
            case (temperature)  
                8'd0: begin  
                    frequency <= 4'b0001; // 1x frequency  
                    voltage <= 4'b0001;   // 1V  
                end  
                8'd50: begin  
                    frequency <= 4'b0010; // 2x frequency  
                    voltage <= 4'b0010;   // 1.5V  
                end  
                8'd100: begin  
                    frequency <= 4'b0011; // 3x frequency  
                    voltage <= 4'b0011;   // 1.8V  
                end  
                8'd150: begin  
                    frequency <= 4'b0100; // 4x frequency  
                    voltage <= 4'b0100;   // 2V  
                end  
                8'd200: begin  
                    frequency <= 4'b0101; // 5x frequency  
                    voltage <= 4'b0101;   // 2.5V  
                end  
                default: begin  
                    frequency <= 4'b0000;  
                    voltage <= 4'b0000;  
                end  
            endcase  
        end  
    end  
endmodule