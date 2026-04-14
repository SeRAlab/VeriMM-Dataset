module PLL_4x(  
    input wire clk_in,  
    input wire reset,  
    output reg clk_out  
);  
    reg [1:0] state; // State for the VCO  
    reg [3:0] counter; // Counter for generating 4x frequency  
    parameter IDLE = 2'b00, RUN = 2'b01;  
  
    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            counter <= 0;  
            clk_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    state <= RUN;  
                end  
                RUN: begin  
                    counter <= counter + 1;  
                    if (counter == 3) begin  
                        clk_out <= ~clk_out;  
                        counter <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule