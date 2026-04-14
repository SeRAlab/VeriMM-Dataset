module sd_card_controller(
    input wire clk,
    input wire rst,
    input wire cmd,          // 1 for read, 0 for write
    input wire [7:0] data_in,
    output reg ack,
    output reg [7:0] data_out
);
    reg [1:0] state, next_state;

    localparam IDLE = 2'b00,
               READ = 2'b01,
               WRITE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                ack = 0;
                if (cmd) 
                    next_state = READ;
                else 
                    next_state = WRITE;
            end
            READ: begin
                ack = 0;
                data_out = data_in; // Assume data_in is the read data from SD card
                next_state = IDLE;
            end
            WRITE: begin
                ack = 1; // Acknowledge write operation
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule