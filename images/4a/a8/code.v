module prbs_generator(
    input clk,
    input reset,
    output reg [6:0] prbs
    );
    
    always @(posedge clk) begin
        if (reset)
            prbs <= 7'b0000001;
        else
            prbs <= {prbs[5:0], prbs[6] ^ prbs[5]};
    end
endmodule