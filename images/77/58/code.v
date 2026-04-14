module debouncer(
    input           clk,
    input           reset,
    input           switch_in,

    output reg      switch_out
);

parameter THRESHOLD = 1000;
reg [9:0] counter;
reg switch_state;

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        counter <= 0;
        switch_state <= 0;
        switch_out <= 0;
    end else begin
        if (switch_in == switch_state) begin
            if (counter < THRESHOLD) begin
                counter <= counter + 1;
            end else begin
                switch_out <= switch_state;
            end
        end else begin
            counter <= 0;
            switch_state <= switch_in;
        end
    end
end

endmodule