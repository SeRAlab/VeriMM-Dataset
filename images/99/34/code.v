module top_module(
        output wire [3:0] data_out,
        output wire tc,
        output wire zero,
        input wire loadn, clock, clear, enable,
        input wire [3:0] data_in
    );reg [ 3: 0 ] cur_state;
    assign data_out = cur_state; 

    assign zero = (cur_state == 0) ? 1 : 0;
    assign tc = ((cur_state == 0) & enable) ? 1 : 0;

    always @(posedge clock)
    begin: COUNTER
        if (enable) begin
            if (cur_state == 4'b0000) begin
                cur_state <= 4'd9;
                
            end
            else begin
                cur_state <= cur_state - 1;
                
            end
        end
        else begin
            if (!loadn) begin
                cur_state <= data_in;
            end
        end
    end

    always @(negedge clear) begin
        if (!clear) begin
            cur_state <= 4'b0000;
            
        end
    end

endmodule