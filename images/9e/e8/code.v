module parallel_load_register
    (
        input rst_n,
        input clk,
        input load,
        input [5:0] data,
        output reg [5:0] q
    );

    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)
            q <= 6'd0;
        else if (load)
            q <= data;
    end

endmodule