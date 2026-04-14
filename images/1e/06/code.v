module fractional_n_pll #(parameter N = 4) (  
    input wire clk_ref,  
    input wire reset,  
    input wire [N-1:0] fractional_value,  
    output reg clk_out  
);  
    reg [N-1:0] divider;  
    reg [N-1:0] counter;  
    reg [1:0] state;  
    parameter IDLE = 2'b00,  
              COUNT = 2'b01,  
              OUTPUT = 2'b10;  

    always @(posedge clk_ref or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            counter <= 0;  
            divider <= 0;  
            clk_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    divider <= fractional_value;  
                    state <= COUNT;  
                end  
                COUNT: begin  
                    if (counter < divider) begin  
                        counter <= counter + 1;  
                    end else begin  
                        clk_out <= ~clk_out;  
                        counter <= 0;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    state <= COUNT;  
                end  
            endcase  
        end  
    end  
endmodule