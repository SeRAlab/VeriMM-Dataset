module sd_card_controller(  
    input wire clk,  
    input wire reset,  
    input wire cmd,  // 0 for write, 1 for read  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  
    reg [1:0] state;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            data_out <= 16'b0;  
        end else begin  
            case (state)  
                0: begin  
                    if (cmd == 0) begin  // Write Command  
                        memory <= data_in;  
                        state <= 1;  
                    end else if (cmd == 1) begin  // Read Command  
                        state <= 2;  
                    end  
                end  
                1: begin  
                    data_out <= memory;  // Immediately output data after write  
                    state <= 0;  
                end  
                2: begin  
                    data_out <= memory;  // Output data after two clock cycles  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule