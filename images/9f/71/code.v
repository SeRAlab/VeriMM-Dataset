module top_module(
    input clk, // clock signal
    input async_sig, // asynchronous signal
    input rst, // reset signal
    input en, // enable signal
    output rise, // rising edge detected
    output fall // falling edge detected
);reg async_d; // asynchronous signal delayed by one clock cycle
    reg async_dd; // asynchronous signal delayed by two clock cycles
    reg rise_d; // rising edge delayed by one clock cycle
    reg fall_d; // falling edge delayed by one clock cycle
    
    // Detect rising edge
    always @ (posedge clk) begin
        async_d <= async_sig;
        rise_d <= async_d & ~async_dd & en;
        async_dd <= async_d;
    end
    
    // Detect falling edge
    always @ (negedge clk) begin
        fall_d <= ~async_d & async_dd & en;
    end
    
    // Output pulses
    assign rise = rst ? 1'b0 : rise_d;
    assign fall = rst ? 1'b0 : fall_d;
    
endmodule