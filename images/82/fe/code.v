module top_module(
    input clk,
    input reset,   // Asynchronous active-low reset
    input slowena, // Control signal to enable/disable counting
    output reg [3:0] q // 4-bit output in binary form
);// Johnson counter
    reg [3:0] johnson_q;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            johnson_q <= 4'b0000;
        end else begin
            johnson_q <= {johnson_q[2:0], ~johnson_q[3]}; // Johnson counter logic
        end
    end
    
    // Decade counter
    reg [3:0] decade_q;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            decade_q <= 4'b0000;
        end else if (slowena) begin
            decade_q <= decade_q + 1;
        end
    end
    
    // Output sum of both counters
    reg [3:0] sum;
    always @(johnson_q, decade_q) begin
        sum = johnson_q + decade_q;
    end
    
    // Control logic to enable/disable counting
    reg slowena_d;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            slowena_d <= 1'b0;
        end else begin
            slowena_d <= slowena;
        end
    end
    
    // Output sum or last output value based on control signal
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q <= 4'b0000;
        end else if (slowena_d) begin
            q <= sum;
        end else begin
            q <= q; // Maintain current value
        end
    end

endmodule