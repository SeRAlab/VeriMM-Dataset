module crystal_oscillator(  
    input wire clk,  
    input wire reset,  
    input wire [2:0] freq_sel,  
    output reg out  
);  
    reg [23:0] counter;  
    reg [23:0] max_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            out <= 0;  
            max_count <= 0;  
        end else begin  
            if (counter < max_count) begin  
                counter <= counter + 1;  
            end else begin  
                out <= ~out;  
                counter <= 0;  
            end  
        end  
    end  

    always @(*) begin  
        case(freq_sel)  
            3'b000: max_count = 24'd999999; // 1 Hz  
            3'b001: max_count = 24'd499999; // 2 Hz  
            3'b010: max_count = 24'd249999; // 4 Hz  
            3'b011: max_count = 24'd124999; // 8 Hz  
            3'b100: max_count = 24'd62499;  // 16 Hz  
            default: max_count = 24'd999999; // Default to 1 Hz  
        endcase  
    end  
endmodule