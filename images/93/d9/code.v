module top_module(
    input A,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);wire clk;
    assign clk = 1'b1;

    reg [4:0] state = 5'bxxxxx;
    reg [4:0] expected_state;

    initial begin
        // Initialize expected_state
        expected_state = 5'b00000; // Set expected_state to all zeros
        Y = 1'b0; // Initialize output Y
    end

    always @(posedge clk) begin
        state <= {state[3:0], A};
        
        // Check the state and set Y accordingly
        if (state == expected_state) begin
            Y <= 1'b1;
        end else if (state == ~expected_state) begin
            Y <= 1'b0; 
        end else begin
            Y <= 1'bx; 
        end
    end

endmodule