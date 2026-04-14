module pulse_generator(  
    input wire clk,  
    input wire rst,  
    input wire trigger,  
    input wire [3:0] pulse_width,  
    output reg pulse_out  
);  
    reg [3:0] count;  
    reg generating;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            pulse_out <= 0;  
            count <= 0;  
            generating <= 0;  
        end else if (trigger && !generating) begin  
            generating <= 1;  
            count <= pulse_width;  
        end else if (generating) begin  
            if (count > 0) begin  
                pulse_out <= 1;  
                count <= count - 1;  
            end else begin  
                pulse_out <= 0;  
                generating <= 0;  
            end  
        end  
    end  
endmodule