module pitch_detector(  
    input clk,  
    input reset,  
    input [7:0] frequency,  
    output reg [3:0] pitch_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            pitch_out <= 4'b0000;  
        else begin  
            if (frequency < 8'd50)  
                pitch_out <= 4'b0000; // C  
            else if (frequency < 8'd100)  
                pitch_out <= 4'b0001; // D  
            else if (frequency < 8'd150)  
                pitch_out <= 4'b0010; // E  
            else if (frequency < 8'd200)  
                pitch_out <= 4'b0011; // F  
            else if (frequency < 8'd250)  
                pitch_out <= 4'b0100; // G  
            else if (frequency < 8'd300)  
                pitch_out <= 4'b0101; // A  
            else  
                pitch_out <= 4'b0110; // B  
        end  
    end  
endmodule