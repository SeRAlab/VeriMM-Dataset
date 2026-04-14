module rand_delay_r (
    clk_core,
    rst_x,
    i_en,
    i_delay,
    i_data,
    o_data
);
    parameter P_WIDTH     = 8;
    parameter P_NUM_DELAY = 8;
    input                clk_core;
    input                rst_x;
    input                i_en;
    input  [7:0] 	 i_delay;
    input  [P_WIDTH-1:0] i_data;
    output [P_WIDTH-1:0] o_data;
    reg   [P_WIDTH-1:0] r_delay[0:P_NUM_DELAY-1];
    assign o_data =  (i_delay < P_NUM_DELAY) ? r_delay[i_delay] : 
                                               r_delay[P_NUM_DELAY-1];
    always @(posedge clk_core) begin
        if (i_en) r_delay[0] <= i_data;
    end
    integer i;
    always @(posedge clk_core or negedge rst_x) begin
        if (!rst_x) begin
            if ( P_NUM_DELAY > 1 ) begin
                for ( i = 1; i < P_NUM_DELAY; i = i + 1) begin
                    r_delay[i] <= 0;
                end
            end
        end else begin
            if ( P_NUM_DELAY > 1 ) begin
                for ( i = 1; i < P_NUM_DELAY; i = i + 1) begin
                    if (i_en) r_delay[i] <= r_delay[i-1];
                end
            end
        end
    end
endmodule