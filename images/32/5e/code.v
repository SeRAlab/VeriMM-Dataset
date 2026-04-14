module rc_oscillator (  
    input wire clk,  
    input wire [7:0] resistor_value,  
    input wire [7:0] capacitor_value,  
    output reg oscillator_out  
);  
    integer count;  
    parameter MAX_COUNT = 255;  

    always @(posedge clk) begin  
        count <= count + 1;  
        if (count >= (resistor_value * capacitor_value)) begin  
            oscillator_out <= ~oscillator_out;  
            count <= 0;  
        end  
    end  
endmodule