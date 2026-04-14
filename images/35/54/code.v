module rs_encoder (
    input wire clk,
    input wire start,
    input wire [3:0] data_in,
    output reg [6:0] encoded_out,
    output reg ready
);
    reg [3:0] data_reg;
    reg [2:0] state;
    
    localparam IDLE = 3'b000,
               PROCESS = 3'b001,
               OUTPUT = 3'b010;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                ready <= 0;
                if (start) begin
                    data_reg <= data_in;
                    state <= PROCESS;
                end
            end
            
            PROCESS: begin
                // Simple encoding logic (dummy for illustration)
                encoded_out <= {data_reg, data_reg[3:0] ^ 4'b1010}; // Example encoding
                state <= OUTPUT;
            end
            
            OUTPUT: begin
                ready <= 1;
                state <= IDLE; // Go back to IDLE after output
            end
            
            default: state <= IDLE;
        endcase
    end
endmodule