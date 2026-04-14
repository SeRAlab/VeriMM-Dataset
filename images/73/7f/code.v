module top_module(
    input [3:0] D,
    input LOAD,
    input SHIFT,
    output reg [3:0] Q
);always @ (posedge SHIFT) begin
        Q <= {Q[2:0], 1'b0};
    end
    
    always @ (posedge LOAD) begin
        if (LOAD) begin
            Q <= D;
        end
    end

endmodule