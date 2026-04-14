module nvme_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] state_input,
    output reg [1:0] current_state
);
    // State encoding
    localparam IDLE  = 2'b00;
    localparam READ  = 2'b01;
    localparam WRITE = 2'b10;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            case (state_input)
                IDLE:  current_state <= IDLE;
                READ:  current_state <= READ;
                WRITE: current_state <= WRITE;
                default: current_state <= current_state; // Remain in current state for '11'
            endcase
        end
    end
endmodule