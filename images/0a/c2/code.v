module pulse_generator(  
    input clk,  
    input rst,  
    input pulse_in,  
    input [3:0] pulse_width,  
    output reg pulse_out  
);  
    reg [3:0] count;  
    reg state;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            pulse_out <= 0;  
            state <= 0;  
        end else begin  
            if (pulse_in && !state) begin  
                state <= 1;  
                count <= 0;  
            end else if (state) begin  
                if (count < pulse_width) begin  
                    pulse_out <= 1;  
                    count <= count + 1;  
                end else begin  
                    pulse_out <= 0;  
                    state <= 0;  
                end  
            end  
        end  
    end  
endmodule