module top_module(
    input clk,
    input sig,
    output reg [13:0] f
);parameter F_CLK=40000; //Clock frequency in HUNDREDS OF Hz.
parameter ERR=5; //Allowable frequency measurement error, HUNDREDS OF Hz.
parameter NUM_CNTS_AVG=F_CLK/ERR; //Number of clock edge counts required such that averaging reduces +-1 count error to acceptable levels.
parameter F_SCALE=ERR; //Scale RF signal counter by this amount to give a frequency measurement in HUNDREDS OF Hz.
parameter N_SIG_MAX=1023; //Maximum value sig edge counter can reach.

reg [13:0] n_clk; //Counter for clock positive edges.
reg [9:0] n_sig; //Counter for signal positive edges.
reg reset; //Reset flag set every NUM_CNTS_AVG clock cycles to re-compute frequency and restart counters.

initial begin
    reset=1'b1; //Initialize reset signal counter flag low so that counting only starts when gate is actually opened.
    n_clk=14'b0; //Initialize clock counter.
    n_sig=10'b0; //Initialize signal counter.
end

always @(posedge clk) begin
    if(n_clk>=NUM_CNTS_AVG) begin //Close frequency counter gate. Subtract one from count because actually start counting signal edges at n_clk=1.
        f=F_SCALE*n_sig; //Compute frequency.
        reset = 1'b1; //Set flag to re-compute the frequency and restart the frequency counter.
        n_clk = 1'b0; //Restart clock positive edge counter.
    end else begin
        reset = 1'b0; //Keep reset flag low (turn off on next clock cycle).
        n_clk=n_clk+1; //Increment clock cycle counter.
    end
end

always @(posedge sig or posedge reset) begin
    if(reset==1) begin
        n_sig=10'b0; //Reset RF signal counter.
    end else if(n_sig<=N_SIG_MAX) begin //Handle overflow gracefully - stop counting when register is saturated.
        n_sig=n_sig+1; //Increment frequency counter.
    end
end

endmodule