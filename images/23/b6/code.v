module i2c_controller(  
    input wire clk,  
    input wire start,  
    input wire stop,  
    output reg SDA,  
    output reg SCL  
);  
    reg state;  

    always @(posedge clk) begin  
        if (start) begin  
            SDA <= 0;  // Start condition  
            state <= 1;  
        end else if (stop) begin  
            SDA <= 1;  // Stop condition  
            state <= 0;  
        end else begin  
            SCL <= ~SCL;  // Toggle SCL  
            if (state) begin  
                SDA <= 0;  // During data transmission  
            end else begin  
                SDA <= 1;  // Idle state  
            end  
        end  
    end  
endmodule