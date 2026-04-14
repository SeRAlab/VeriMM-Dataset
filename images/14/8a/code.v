module ButterworthFilter (input [4:0] signal_in, output reg [4:0] signal_out);  
    reg [4:0] x1, x2; // Previous input values  
    reg [4:0] y1, y2; // Previous output values  

    always @(*) begin  
        // 2nd order Butterworth filter difference equation  
        signal_out = (signal_in + x1 + x2 - y1 - y2) >> 1;  
        // Update previous values  
        x2 = x1;  
        x1 = signal_in;  
        y2 = y1;  
        y1 = signal_out;  
    end  
endmodule