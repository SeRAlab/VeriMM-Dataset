module ofdm_modulator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [7:0] modulated_out
);
    reg [1:0] state;
    reg [3:0] data_buffer;
    
    // State encoding
    localparam IDLE = 2'b00,
               READ = 2'b01,
               MODULATE = 2'b10;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            modulated_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= READ;
                end
                READ: begin
                    data_buffer <= data_in;
                    state <= MODULATE;
                end
                MODULATE: begin
                    // Simple mapping: Binary to frequency mapping
                    modulated_out <= {data_buffer, 4'b0}; // Example mapping
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule