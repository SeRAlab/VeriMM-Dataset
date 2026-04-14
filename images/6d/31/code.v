module top_module(
    result,
    carry,
    operand_a,
    shift,
    round
);parameter  width = 8;

    output  [width-1:0] result;
    output              carry;

    input   [width-1:0] operand_a;
    input   [width-1:0] shift;
    input               round;

    wire    [width-1:0] mux_ctrl;
    reg     [width-1:0] result;
    reg     [width-1:0] mux_net     [width:0];
    reg                 carry;
    
    assign mux_ctrl = shift;

    integer i;
    always @ * 
    begin
        mux_net[0] = operand_a;
        for(i = 0; i < width; i = i + 1)
        begin
            if(mux_ctrl[i])
            begin
                mux_net[i+1][width-1:1] = mux_net[i][width-2:0];
                mux_net[i+1][0] = round & mux_net[i][width-1];
            end
            else
            begin
                mux_net[i+1] = mux_net[i];
            end
        end
        carry = mux_net[width-2][width-1];
        result = mux_net[width-1];
    end

endmodule