module pulse_generator(  
    input wire clk,  
    input wire trigger,  
    input wire [3:0] pulse_width, // pulse width in clock cycles  
    output reg pulse_out  
);  
    reg [3:0] count;  
    reg generating;  
  
    always @(posedge clk) begin  
        if (trigger) begin  
            generating <= 1;  
            count <= pulse_width;  
        end else if (generating) begin  
            if (count > 0) begin  
                count <= count - 1;  
                pulse_out <= 1;  
            end else begin  
                generating <= 0;  
                pulse_out <= 0;  
            end  
        end  
    end  
endmodule