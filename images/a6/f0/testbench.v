`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rst_n;
    reg wait_end;
    reg wait_start_comport;
    reg wait_start_gluclock;
    wire spiint_n;
    wire wait_n;
    wire [6:0] waits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst_n(rst_n),
        .wait_end(wait_end),
        .wait_start_comport(wait_start_comport),
        .wait_start_gluclock(wait_start_gluclock),
        .spiint_n(spiint_n),
        .wait_n(wait_n),
        .waits(waits)
    );

    // Clock generation (10ns period)
    initial begin
        wait_end = 0;
        forever #5 wait_end = ~wait_end;
    end

        task reset_dut;

    begin
        rst_n = 0;
        wait_start_comport = 0;
        wait_start_gluclock = 0;


        #20;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking reset state", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b0, 7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Setting gluclock wait bit", test_num);
        reset_dut();

        @(negedge wait_end);
        wait_start_gluclock = 1;
        #2;
        wait_start_gluclock = 0;
        #1;

        #1;


        check_outputs(1'b0, 1'bz, 7'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Setting comport wait bit", test_num);
        reset_dut();
        @(negedge wait_end);
        wait_start_comport = 1;
        #2;
        wait_start_comport = 0;
        #1;

        #1;


        check_outputs(1'b0, 1'bz, 7'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Setting both wait bits simultaneously", test_num);
        reset_dut();
        @(negedge wait_end);
        wait_start_gluclock = 1;
        wait_start_comport = 1;
        #2;
        wait_start_gluclock = 0;
        wait_start_comport = 0;
        #1;

        #1;


        check_outputs(1'b0, 1'bz, 7'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Checking wait_end clear logic", test_num);
        reset_dut();
        @(negedge wait_end);
        wait_start_gluclock = 1;
        #2;
        wait_start_gluclock = 0;

        #1;
        if (waits !== 7'h01) $display("Intermediate check failed: waits not set");


        @(posedge wait_end);
        #2;

        #1;


        check_outputs(1'b1, 1'b0, 7'h00);
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
        input expected_spiint_n;
        input expected_wait_n;
        input [6:0] expected_waits;
        begin
            if (expected_spiint_n === (expected_spiint_n ^ spiint_n ^ expected_spiint_n) &&
                expected_wait_n === (expected_wait_n ^ wait_n ^ expected_wait_n) &&
                expected_waits === (expected_waits ^ waits ^ expected_waits)) begin
                $display("PASS");
                $display("  Outputs: spiint_n=%b, wait_n=%b, waits=%h",
                         spiint_n, wait_n, waits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spiint_n=%b, wait_n=%b, waits=%h",
                         expected_spiint_n, expected_wait_n, expected_waits);
                $display("  Got:      spiint_n=%b, wait_n=%b, waits=%h",
                         spiint_n, wait_n, waits);
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
        $dumpvars(0,rst_n, wait_end, wait_start_comport, wait_start_gluclock, spiint_n, wait_n, waits);
    end

endmodule
