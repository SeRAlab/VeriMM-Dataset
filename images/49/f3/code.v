module top_module(
    output reg Q,  // Changed to output reg to store the state
    input CLK,
    input D
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Wire to hold the D input value
    wire D_wire;
    
    // Creating a negative-edge triggered D flip-flop using the basic flip-flop structure and behavioral modeling
    always @(posedge CLK) begin
        Q <= D;  // Update Q with the value of D at the rising edge of CLK
    end

endmodule