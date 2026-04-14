module top_module(
    input clk,
    input pause,
    input reset,
    input a,
    input b,
    output reg [3:0] q,
    output reg out
);// Implement XOR gate using behavioral always block
    always @ (a, b) begin
        out = a ^ b;
    end
    
    // Implement XOR gate using structural implementation using a MUX
    wire mux_sel = pause;
    wire [1:0] mux_in = {q[0], out};
    wire mux_out;
    assign mux_out = mux_sel ? mux_in[1] : mux_in[0];
    
    // Implement decade counter using Johnson counter and D flip-flop
    reg [3:0] johnson_out;
    always @ (posedge clk, negedge reset) begin
        if (!reset) begin
            johnson_out <= 4'b0001;
        end else begin
            johnson_out <= {johnson_out[2:0], ~johnson_out[3]};
        end
    end
    
    reg [3:0] dff_out;
    always @ (posedge clk, negedge reset) begin
        if (!reset) begin
            dff_out <= 4'b0000;
        end else if (!pause) begin
            dff_out <= johnson_out;
        end
    end
    
    // Output the XOR gate output when paused, and the current count value when not paused
    always @ (posedge clk) begin
        if (pause) begin
            q <= dff_out;
        end else begin
            q <= johnson_out;
        end
    end

endmodule