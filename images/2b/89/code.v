module pcie_packet_processor (
    input clk,
    input reset,
    input [7:0] packet_in,
    output reg valid_packet
);
    parameter START_SEQ = 8'hAB; // Start of packet sequence
    parameter END_SEQ = 8'hCD;   // End of packet sequence
    
    reg [1:0] state; // State variable
    localparam IDLE = 2'b00, START = 2'b01, END = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            valid_packet <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (packet_in == START_SEQ) begin
                        state <= START;
                    end
                end
                START: begin
                    if (packet_in == END_SEQ) begin
                        valid_packet <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule