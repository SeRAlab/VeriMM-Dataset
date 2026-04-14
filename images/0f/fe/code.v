module sata_controller(
    input clk,
    input rst,
    input start,
    input read_cmd,
    input write_cmd,
    input done,
    output reg [1:0] state // 2 bits for states: 00 - IDLE, 01 - READ, 10 - WRITE
);

    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        if (read_cmd) 
                            state <= READ;
                        else if (write_cmd) 
                            state <= WRITE;
                    end
                end
                READ: begin
                    if (done) 
                        state <= IDLE;
                end
                WRITE: begin
                    if (done) 
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule