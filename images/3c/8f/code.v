module sd_card_controller(
    input wire clk,
    input wire reset,
    input wire [1:0] cmd, // 00: Read, 01: Write, 10: No Operation
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready,
    output reg error
);
    
    reg [1:0] state, next_state;
    
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ready <= 1;
            error <= 0;
            data_out <= 8'b0;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                ready = 1;
                if (cmd == 2'b01) begin // Write Command
                    next_state = WRITE;
                    ready = 0;
                end else if (cmd == 2'b00) begin // Read Command
                    next_state = READ;
                    ready = 0;
                end
            end
            READ: begin
                data_out = 8'hAA; // Simulated read data
                next_state = IDLE; // Go back to idle after read
            end
            WRITE: begin
                if (data_in == 8'hFF) begin // Simulate error condition
                    error = 1; 
                end else begin
                    error = 0; // Write successful
                end
                next_state = IDLE; // Go back to idle after write
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule