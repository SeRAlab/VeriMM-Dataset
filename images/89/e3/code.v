module top_module(next_in, clock, reset, ena, current_out);localparam              MSB = 31;
    
    localparam              SHIFT = 32'h0;
    input       [MSB:0]     next_in;
    input                   clock, reset, ena;
    output reg  [MSB:0]     current_out;

    always @ ( posedge clock or posedge reset ) begin
        if (reset) begin
            current_out <= SHIFT;
        end else if (ena) begin
            current_out <= next_in;
        end
    end


endmodule