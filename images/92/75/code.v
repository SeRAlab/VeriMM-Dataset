module top_module(
    input clk,
    input [2:0] parallel_load,
    input shift,
    input control,
    output reg [2:0] out
);always @(posedge clk) begin
        if (control == 1'b0) begin // Shift right
            if (shift == 1'b1) begin
                out <= {parallel_load[0], out[2:1]};
            end
        end
        else begin // Shift left
            if (shift == 1'b1) begin
                out <= {out[1:0], parallel_load[2]};
            end
        end
    end
    
    always @(*) begin
        if (control == 1'b0) begin // Shift right
            out = {parallel_load[0], out[2:1]};
        end
        else begin // Shift left
            out = {out[1:0], parallel_load[2]};
        end
    end

endmodule