module ring_counter
    (
        input rst_n,
        input clk,
        output reg [2:0] counter
    );

    reg [2:0] ring;

    always @(posedge clk) 
    begin
        if (!rst_n)
            ring <= 3'b001;
        else
            ring <= {ring[1:0], ring[2]};
    end

    always @(posedge clk)
    begin
        counter <= ring;
    end

endmodule