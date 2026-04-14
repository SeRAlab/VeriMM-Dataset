module ofdm_modulator(  
    input clk,  
    input reset,  
    input [3:0] bit_stream, // 4 bits input for 4 subcarriers  
    input valid,  
    output reg [7:0] ofdm_symbol, // 8 bits output for the OFDM symbol  
    output reg symbol_valid  
);  
    reg [3:0] data_buffer [0:3]; // Buffer for subcarriers  
    reg [1:0] state;  
    reg [1:0] count;  

    localparam IDLE = 2'b00, LOAD = 2'b01, IFFT = 2'b10, OUTPUT = 2'b11;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            count <= 0;  
            symbol_valid <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid) begin  
                        state <= LOAD;  
                    end  
                end  
                LOAD: begin  
                    data_buffer[count] <= bit_stream;  
                    count <= count + 1;  
                    if (count == 3) begin  
                        state <= IFFT;  
                        count <= 0;  
                    end  
                end  
                IFFT: begin  
                    // Simple IFFT calculation (for demonstration purpose, just sum the inputs)  
                    ofdm_symbol <= data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    symbol_valid <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule