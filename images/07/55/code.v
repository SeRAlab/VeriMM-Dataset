module VCO (  
    input wire clk,  
    input wire reset,  
    input wire [2:0] control,  
    output reg freq_out  
);  
    reg [23:0] counter;  
    reg [23:0] freq_div;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            freq_div <= 24'd1000000; // Base frequency divisor for 1 MHz  
        end else begin  
            case (control)  
                3'b000: freq_div <= 24'd1000000; // 1 MHz  
                3'b001: freq_div <= 24'd500000;  // 2 MHz  
                3'b010: freq_div <= 24'd250000;  // 4 MHz  
                3'b011: freq_div <= 24'd125000;  // 8 MHz  
                3'b100: freq_div <= 24'd62500;   // 16 MHz  
                default: freq_div <= 24'd1000000; // default to 1 MHz  
            endcase  
            if (counter == freq_div) begin  
                freq_out <= ~freq_out;  
                counter <= 0;  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  
endmodule