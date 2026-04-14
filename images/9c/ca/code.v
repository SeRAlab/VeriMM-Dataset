module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the register
    input [7:0] in, // 8-bit input for the edge detector
    output [7:0] q, // 8-bit output from the register
    output [7:0] edge_out, // 8-bit output from the edge detector
    output reg [3:0] counter_out, // 4-bit output from the counter
    output [7:0] final_output // 8-bit output from the functional module
);reg [7:0] reg_q;

always @(posedge clk) begin
    if (reset) begin
        reg_q <= 8'h34;
    end else begin
        reg_q <= d;
    end
end

assign q = reg_q;

reg [7:0] prev_in;
reg edge_detected;

always @(posedge clk) begin
    if (in[0] && !prev_in[0]) begin
        edge_detected <= 1;
    end else if (!in[0] && prev_in[0]) begin
        edge_detected <= 0;
    end
    prev_in <= in;
end

assign edge_out = edge_detected;

parameter [2:0] IDLE = 3'b000, COUNT = 3'b001, RESET = 3'b010;
reg [2:0] state;

always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (edge_detected) begin
                state <= COUNT;
            end else begin
                state <= IDLE;
            end
        end
        COUNT: begin
            if (counter_out == 4'h9) begin
                state <= RESET;
            end else begin
                state <= COUNT;
            end
        end
        RESET: begin
            state <= IDLE;
        end
    endcase
end

always @(posedge clk) begin
    case (state)
        IDLE: begin
            counter_out <= 4'h0;
        end
        COUNT: begin
            counter_out <= counter_out + 1;
        end
        RESET: begin
            counter_out <= 4'h0;
        end
    endcase
end

assign final_output = counter_out | edge_detected;

endmodule