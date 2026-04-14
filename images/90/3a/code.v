module top_module(
    input D, 
    input C, 
    input R, 
    input S, 
    output reg Q  // Changed from output to output reg
    );always @(posedge C) begin
        if (R) begin
            Q <= 0;
        end else if (S) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule