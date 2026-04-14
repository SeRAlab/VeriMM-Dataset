module sd_card_controller (
    input wire clk,
    input wire rst,
    input wire start_read,
    input wire start_write,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg busy,
    output reg error
);

    reg [1:0] state;
    reg [7:0] buffer;
    
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;
    localparam ERROR = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            error <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) begin
                        state <= READ;
                        busy <= 1;
                        error <= 0;
                    end else if (start_write) begin
                        state <= WRITE;
                        busy <= 1;
                        error <= 0;
                    end
                end
                
                READ: begin
                    // Simulate read operation
                    data_out <= buffer; // Assume buffer is filled elsewhere
                    state <= IDLE;
                    busy <= 0;
                end
                
                WRITE: begin
                    // Simulate write operation
                    buffer <= data_in; // Write data to buffer
                    state <= IDLE;
                    busy <= 0;
                end
                
                ERROR: begin
                    error <= 1;
                    busy <= 0;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule