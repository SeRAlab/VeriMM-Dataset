module pulse_generator(  
    input wire clk,  
    input wire [3:0] pulse_width,  
    output reg pulse_out  
);  
    reg [3:0] count;  
    always @(posedge clk) begin  
        if (count < pulse_width) begin  
            pulse_out <= 1;  
            count <= count + 1;  
        end else begin  
            pulse_out <= 0;  
            if (count == 15)  
                count <= 0;  
            else  
                count <= count + 1;  
        end  
    end  
endmodule