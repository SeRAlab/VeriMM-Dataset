module spi_master (  
    input wire clk,            // System clock  
    input wire reset_n,        // Active low reset  
    input wire start,          // Start signal for the transaction  
    input wire [7:0] data_in,  // Data to transmit  
    input wire miso,           // Master In Slave Out  
    output reg mosi,           // Master Out Slave In  
    output reg sck,            // Serial Clock  
    output reg ss,             // Slave Select  
    output reg [7:0] data_out, // Data received  
    output reg done            // Transaction done signal  
);  
    reg [2:0] bit_count;       // Bit counter  
    reg state;                 // State of the SPI machine  
    localparam IDLE = 1'b0, TRANSMIT = 1'b1;  
     
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            state <= IDLE;  
            mosi <= 1'b0;  
            sck <= 1'b0;  
            ss <= 1'b1;  
            data_out <= 8'b0;  
            bit_count <= 3'b0;  
            done <= 1'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        ss <= 1'b0; // Activate slave  
                        bit_count <= 3'b0;  
                        state <= TRANSMIT;  
                        done <= 1'b0;  
                    end  
                end  
                TRANSMIT: begin  
                    sck <= ~sck; // Toggle clock  
                    if (sck) begin  
                        mosi <= data_in[7-bit_count]; // Send data  
                    end else begin  
                        data_out[7-bit_count] <= miso; // Receive data  
                        bit_count <= bit_count + 1;  
                        if (bit_count == 3'd7) begin  
                            ss <= 1'b1; // Deactivate slave  
                            state <= IDLE;  
                            done <= 1'b1;  
                        end  
                    end  
                end  
            endcase  
        end  
    end  
endmodule