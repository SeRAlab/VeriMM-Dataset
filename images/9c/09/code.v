module top_module(
    input wire CLK,
    input wire RST,
    input wire [31:0] MAX_VAL,
    output reg [31:0] COUNT,
    output reg DONE
);always @(posedge CLK) begin
        if(RST) begin
            COUNT <= 0;
            DONE <= 0;
        end else begin
            COUNT <= COUNT + 1;
            if(COUNT == MAX_VAL) begin
                DONE <= 1;
            end else begin
                DONE <= 0;
            end
        end
    end

endmodule