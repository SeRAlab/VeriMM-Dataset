module sd_card_interface(  
    input wire CLK,  
    input wire RESET,  
    input wire CMD,  
    input wire [7:0] DATA_IN,  
    output reg [7:0] DATA_OUT,  
    output reg READY  
);  
    reg [7:0] internal_data;  
    reg state; // 0 = reading, 1 = writing  

    always @(posedge CLK or posedge RESET) begin  
        if (RESET) begin  
            internal_data <= 8'b0;  
            DATA_OUT <= 8'b0;  
            READY <= 1;  
            state <= 0;  
        end else begin  
            if (CMD) begin // Write command  
                internal_data <= DATA_IN;  
                READY <= 1;  
                state <= 1;  
            end else begin // Read command  
                DATA_OUT <= internal_data;  
                READY <= 1;  
                state <= 0;  
            end  
        end  
    end  
endmodule