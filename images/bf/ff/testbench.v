`timescale 1ns/1ps

module rtc_tb;

    // Testbench signals (sequential circuit)
    reg adj_ld;
    reg [31:0] adj_ld_data;
    reg clk;
    reg [39:0] period_adj;
    reg [39:0] period_in;
    reg period_ld;
    reg rst;
    reg time_ld;
    reg [37:0] time_reg_ns_in;
    reg [47:0] time_reg_sec_in;
    wire adj_ld_done;
    wire time_one_pps;
    wire [31:0] time_ptp_ns;
    wire [47:0] time_ptp_sec;
    wire [37:0] time_reg_ns;
    wire [47:0] time_reg_sec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rtc dut (
        .adj_ld(adj_ld),
        .adj_ld_data(adj_ld_data),
        .clk(clk),
        .period_adj(period_adj),
        .period_in(period_in),
        .period_ld(period_ld),
        .rst(rst),
        .time_ld(time_ld),
        .time_reg_ns_in(time_reg_ns_in),
        .time_reg_sec_in(time_reg_sec_in),
        .adj_ld_done(adj_ld_done),
        .time_one_pps(time_one_pps),
        .time_ptp_ns(time_ptp_ns),
        .time_ptp_sec(time_ptp_sec),
        .time_reg_ns(time_reg_ns),
        .time_reg_sec(time_reg_sec)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rtc Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_adj_ld_done;
        input expected_time_one_pps;
        input [31:0] expected_time_ptp_ns;
        input [47:0] expected_time_ptp_sec;
        input [37:0] expected_time_reg_ns;
        input [47:0] expected_time_reg_sec;
        begin
            if (expected_adj_ld_done === (expected_adj_ld_done ^ adj_ld_done ^ expected_adj_ld_done) &&
                expected_time_one_pps === (expected_time_one_pps ^ time_one_pps ^ expected_time_one_pps) &&
                expected_time_ptp_ns === (expected_time_ptp_ns ^ time_ptp_ns ^ expected_time_ptp_ns) &&
                expected_time_ptp_sec === (expected_time_ptp_sec ^ time_ptp_sec ^ expected_time_ptp_sec) &&
                expected_time_reg_ns === (expected_time_reg_ns ^ time_reg_ns ^ expected_time_reg_ns) &&
                expected_time_reg_sec === (expected_time_reg_sec ^ time_reg_sec ^ expected_time_reg_sec)) begin
                $display("PASS");
                $display("  Outputs: adj_ld_done=%b, time_one_pps=%b, time_ptp_ns=%h, time_ptp_sec=%h, time_reg_ns=%h, time_reg_sec=%h",
                         adj_ld_done, time_one_pps, time_ptp_ns, time_ptp_sec, time_reg_ns, time_reg_sec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adj_ld_done=%b, time_one_pps=%b, time_ptp_ns=%h, time_ptp_sec=%h, time_reg_ns=%h, time_reg_sec=%h",
                         expected_adj_ld_done, expected_time_one_pps, expected_time_ptp_ns, expected_time_ptp_sec, expected_time_reg_ns, expected_time_reg_sec);
                $display("  Got:      adj_ld_done=%b, time_one_pps=%b, time_ptp_ns=%h, time_ptp_sec=%h, time_reg_ns=%h, time_reg_sec=%h",
                         adj_ld_done, time_one_pps, time_ptp_ns, time_ptp_sec, time_reg_ns, time_reg_sec);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,adj_ld, adj_ld_data, clk, period_adj, period_in, period_ld, rst, time_ld, time_reg_ns_in, time_reg_sec_in, adj_ld_done, time_one_pps, time_ptp_ns, time_ptp_sec, time_reg_ns, time_reg_sec);
    end

endmodule
