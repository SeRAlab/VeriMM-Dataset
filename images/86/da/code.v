module shift_register
    (
        input rst_n, 
        input clk, 
        input shift, 
        input data_in, 
        output reg [7:0] q
    );

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            q <= 8'b0;
        else
        begin
            if (shift)
                q <= {data_in, q[7:1]};
            else
                q <= {q[6:0], data_in};
        end
    end

endmodule