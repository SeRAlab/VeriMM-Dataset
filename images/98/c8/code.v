module top_module(

    input clock,
    input load,

    output reg max_count,
    output reg [3:0] count_out

);always @(posedge clock)
    begin
        if (load)
        begin
            count_out <= 4'd0;
            max_count <= 1'b0;
        end
        else
        begin
            count_out <= count_out + 4'd1;
            if (count_out == 4'd15)
                max_count <= 1'b1;
            else
                max_count <= 1'b0;
        end
    end

endmodule