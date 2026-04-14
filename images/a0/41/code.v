module top_module(
    input clk,
    input rst,
    input start,
    input load,
    input [31:0] value,
    output reg done,
    output reg [31:0] out
);// Define the internal signals
reg [31:0] count;
reg [31:0] load_value;
reg [1:0] state;

// Define the states
parameter IDLE = 2'b00;
parameter COUNTING = 2'b01;
parameter LOADING = 2'b10;

// Initialize the signals and state
initial begin
    count = 32'b0;
    load_value = 32'b0;
    state = IDLE;
    done = 0;
    out = 32'b0;
end

// Define the state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 32'b0;
        load_value <= 32'b0;
        state <= IDLE;
        done <= 0;
        out <= 32'b0;
    end else begin
        case (state)
            IDLE: begin
                if (load) begin
                    load_value <= value;
                    state <= LOADING;
                end else if (start) begin
                    count <= value;
                    state <= COUNTING;
                    done <= 0; // Ensure done is reset when starting
                end
            end
            COUNTING: begin
                if (count == 0) begin
                    done <= 1;
                    state <= IDLE;
                end else begin
                    count <= count - 1;
                    out <= count;
                end
            end
            LOADING: begin
                count <= load_value;
                state <= IDLE;
            end
        endcase
    end
end

endmodule