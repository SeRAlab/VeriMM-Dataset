module top_module(
    input clk,
    input rst,
    input [15:0] d_in,
    input cs,
    input [3:0] addr,
    input rd,
    input wr,
    output reg [15:0] d_out,
    output reg trigg,
    output reg echo
);// Define the state machine states
parameter IDLE = 2'b00;
parameter TRIG = 2'b01;
parameter ECHO = 2'b10;

// Define the state machine signals and variables
reg [1:0] state;
reg [20:0] i;
reg trig_sent;
reg echo_received;

// Assign default values to the output signals inside the always block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        i <= 0;
        trig_sent <= 1'b0;
        echo_received <= 1'b0;
        trigg <= 1'b0; // Initialize trigg
        echo <= 1'b0;  // Initialize echo
        d_out <= 16'h0000; // Initialize d_out
    end
    else begin
        case (state)
            IDLE: begin
                trigg <= 1'b0;
                if (cs && wr && addr == 4'h0) begin
                    trig_sent <= 1'b1;
                    state <= TRIG;
                end
            end
            TRIG: begin
                trigg <= 1'b1;
                if (!trig_sent && !cs && rd && addr == 4'h0) begin
                    echo_received <= 1'b1;
                    state <= ECHO;
                end
            end
            ECHO: begin
                trigg <= 1'b0;
                echo <= 1'b1;
                if (echo_received && !cs && rd && addr == 4'h0) begin
                    d_out <= i; // Assign output data
                    i <= 0; // Reset counter
                    echo_received <= 1'b0;
                    state <= IDLE;
                    echo <= 1'b0; // Reset echo signal
                end
                else begin
                    i <= i + 1; // Increment counter
                end
            end
        endcase
    end
end

endmodule