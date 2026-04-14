module sd_card_controller (
    input clk,
    input reset,
    input [1:0] command, // 00: init, 01: read, 10: write
    output reg busy,
    output reg [1:0] status // 00: idle, 01: reading, 10: writing
);

    parameter IDLE = 2'b00, READING = 2'b01, WRITING = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            status <= IDLE;
        end else begin
            case (command)
                2'b00: begin // initialize
                    busy <= 1;
                    status <= IDLE;
                    #5 busy <= 0; // simulate initialization time
                end
                2'b01: begin // read
                    busy <= 1;
                    status <= READING;
                    #5 busy <= 0; // simulate read time
                    status <= IDLE;
                end
                2'b10: begin // write
                    busy <= 1;
                    status <= WRITING;
                    #5 busy <= 0; // simulate write time
                    status <= IDLE;
                end
                default: begin
                    busy <= 0;
                    status <= IDLE;
                end
            endcase
        end
    end
endmodule