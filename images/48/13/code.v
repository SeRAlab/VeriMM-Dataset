module top_module(
    input clock,
    input reset,
    input load,
    input enable,
    output reg [6:0] count,
    output reg tc
);always @(posedge clock or posedge reset) begin
        if (reset) begin
            count <= 7'b0;
            tc <= 1'b0;
        end
        else if (enable) begin
            if (load) begin
                // Load a specific value here if needed
            end
            else begin
                if (count == 7'b0111111) begin
                    count <= 7'b0;
                    tc <= 1'b1; // Terminal count
                end
                else begin
                    count <= count + 1;
                    tc <= 1'b0;
                end
            end
        end
    end
endmodule