module uart_transmitter(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire send,  
    output reg tx  
);  
    parameter START_BIT = 1'b0;  
    parameter STOP_BIT  = 1'b1;  
    reg [3:0] bit_count;  
    reg [9:0] shift_reg;  
    reg sending;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            bit_count <= 0;  
            shift_reg <= 10'b1111111111;  
            sending <= 0;  
        end else if (send && !sending) begin  
            sending <= 1;  
            shift_reg <= {STOP_BIT, data_in, START_BIT};  
            bit_count <= 0;  
        end else if (sending) begin  
            if (bit_count < 10) begin  
                tx <= shift_reg[bit_count];  
                bit_count <= bit_count + 1;  
            end else begin  
                sending <= 0;  
                tx <= 1;  
            end  
        end  
    end  
endmodule