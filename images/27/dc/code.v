module fir_filter(  
    input [4:0] x,  
    output reg [4:0] y  
);  
    reg [4:0] x_delayed_1;  
    reg [4:0] x_delayed_2;  
      
    always @(*) begin  
        // Shift registers  
        x_delayed_2 = x_delayed_1;  
        x_delayed_1 = x;  
          
        // FIR filter computation  
        y = (1 * x) + (2 * x_delayed_1) + (1 * x_delayed_2);  
    end  
endmodule