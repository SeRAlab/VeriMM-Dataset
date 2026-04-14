module top_module(q, qbar, clock, data, reset, enable);input data, reset, clock, enable;
    output q, qbar;
    reg q, qbar;

    always @(posedge clock) begin
        if (reset == 0) begin
            q <= 0;
            qbar <= 1;
        end else if (enable == 1) begin
            q <= data;
            qbar <= ~data;
        end
    end
endmodule