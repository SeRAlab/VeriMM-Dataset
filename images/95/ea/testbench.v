`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] burst_consumed_burstcount;
    reg burst_consumed_valid;
    reg burst_ready;
    reg burst_valid;
    reg ctl_clk;
    reg ctl_reset_n;
    wire burst_accepted;
    wire [31:0] burst_counter;
    wire [31:0] burst_next_pending_burstcount;
    wire [31:0] burst_pending_burstcount;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .burst_consumed_burstcount(burst_consumed_burstcount),
        .burst_consumed_valid(burst_consumed_valid),
        .burst_ready(burst_ready),
        .burst_valid(burst_valid),
        .ctl_clk(ctl_clk),
        .ctl_reset_n(ctl_reset_n),
        .burst_accepted(burst_accepted),
        .burst_counter(burst_counter),
        .burst_next_pending_burstcount(burst_next_pending_burstcount),
        .burst_pending_burstcount(burst_pending_burstcount)
    );

    // Clock generation (10ns period)
    initial begin
        ctl_clk = 0;
        forever #5 ctl_clk = ~ctl_clk;
    end

        task reset_dut;

        begin
            ctl_reset_n = 0;
            burst_consumed_burstcount = 0;
            burst_consumed_valid = 0;
            burst_ready = 0;
            burst_valid = 0;
            @(posedge ctl_clk);
            #2 ctl_reset_n = 1;
            @(posedge ctl_clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            burst_valid = 1;
            burst_ready = 1;
            @(posedge ctl_clk);


            burst_valid = 0;
            burst_ready = 0;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            burst_valid = 1;
            burst_ready = 0;
            @(posedge ctl_clk);

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            burst_valid = 1;
            burst_ready = 1;
            @(posedge ctl_clk);

            burst_valid = 0;
            burst_ready = 0;
            burst_consumed_valid = 1;
            burst_consumed_burstcount = 1;
            @(posedge ctl_clk);

            burst_consumed_valid = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            burst_valid = 1;
            burst_ready = 1;
            burst_consumed_valid = 1;
            burst_consumed_burstcount = 1;
            @(posedge ctl_clk);

            burst_valid = 0;
            burst_ready = 0;
            burst_consumed_valid = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            repeat(3) begin
                burst_valid = 1;
                burst_ready = 1;
                @(posedge ctl_clk);
            end


            burst_valid = 0;
            burst_ready = 0;
            burst_consumed_valid = 1;
            burst_consumed_burstcount = 2;
            @(posedge ctl_clk);

            burst_consumed_valid = 0;
            #1;

            check_outputs(0, 2, 1, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            burst_valid = 1;
            burst_ready = 1;
            @(posedge ctl_clk);
            @(posedge ctl_clk);


            burst_valid = 1;
            burst_ready = 1;
            burst_consumed_valid = 1;
            burst_consumed_burstcount = 1;
            #1;

            if (burst_next_pending_burstcount === 32'd2) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;

            @(posedge ctl_clk);
            burst_valid = 0;
            burst_ready = 0;
            burst_consumed_valid = 0;
            #1;

            check_outputs(1, 2, 2, 2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_burst_accepted;
        input [31:0] expected_burst_counter;
        input [31:0] expected_burst_next_pending_burstcount;
        input [31:0] expected_burst_pending_burstcount;
        begin
            if (expected_burst_accepted === (expected_burst_accepted ^ burst_accepted ^ expected_burst_accepted) &&
                expected_burst_counter === (expected_burst_counter ^ burst_counter ^ expected_burst_counter) &&
                expected_burst_next_pending_burstcount === (expected_burst_next_pending_burstcount ^ burst_next_pending_burstcount ^ expected_burst_next_pending_burstcount) &&
                expected_burst_pending_burstcount === (expected_burst_pending_burstcount ^ burst_pending_burstcount ^ expected_burst_pending_burstcount)) begin
                $display("PASS");
                $display("  Outputs: burst_accepted=%b, burst_counter=%h, burst_next_pending_burstcount=%h, burst_pending_burstcount=%h",
                         burst_accepted, burst_counter, burst_next_pending_burstcount, burst_pending_burstcount);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: burst_accepted=%b, burst_counter=%h, burst_next_pending_burstcount=%h, burst_pending_burstcount=%h",
                         expected_burst_accepted, expected_burst_counter, expected_burst_next_pending_burstcount, expected_burst_pending_burstcount);
                $display("  Got:      burst_accepted=%b, burst_counter=%h, burst_next_pending_burstcount=%h, burst_pending_burstcount=%h",
                         burst_accepted, burst_counter, burst_next_pending_burstcount, burst_pending_burstcount);
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
        $dumpvars(0,burst_consumed_burstcount, burst_consumed_valid, burst_ready, burst_valid, ctl_clk, ctl_reset_n, burst_accepted, burst_counter, burst_next_pending_burstcount, burst_pending_burstcount);
    end

endmodule
