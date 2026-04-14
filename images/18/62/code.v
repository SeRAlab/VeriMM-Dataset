module uart_controller #(parameter BAUD_RATE = 9600) (  
    input wire clk,  
    input wire start_tx,  
    input wire [7:0] data_in,  
    output reg tx  
);  
  
    reg [3:0] bit_index;  
    reg [10:0] baud_counter;  
    reg transmitting;  
    reg [10:0] shift_reg;  
  
    always @(posedge clk) begin  
        if (start_tx && !transmitting) begin  
            transmitting <= 1'b1;  
            bit_index <= 0;  
            baud_counter <= 0;  
            shift_reg <= {1'b1, data_in, 1'b0}; // Start bit, data, stop bit  
        end else if (transmitting) begin  
            if (baud_counter < (BAUD_RATE / 115200)) begin  
                baud_counter <= baud_counter + 1'b1;  
            end else begin  
                baud_counter <= 0;  
                tx <= shift_reg[bit_index];  
                bit_index <= bit_index + 1'b1;  
                if (bit_index == 10) begin // 1 start + 8 data + 1 stop = 10 bits  
                    transmitting <= 1'b0;  
                end  
            end  
        end  
    end  
endmodule