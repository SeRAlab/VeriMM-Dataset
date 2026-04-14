`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_50mhz;
    wire clk_1hz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_50mhz(clk_50mhz),
        .clk_1hz(clk_1hz)
    );

    // Clock generation (10ns period)
    initial begin
        clk_50mhz = 0;
        forever #5 clk_50mhz = ~clk_50mhz;
    end

        task reset_dut;

    begin
        $display("Synchronizing to initial state...");


        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying initial state after first clock edge", test_num);
        @(posedge clk_50mhz);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying output remains 0 just before toggle threshold", test_num);

        repeat(TOGGLE_THRESHOLD - 2) @(posedge clk_50mhz);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying toggle to 1 at cycle %0d", test_num, TOGGLE_THRESHOLD);
        @(posedge clk_50mhz);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying toggle back to 0 after full 1s period", test_num);

        repeat(TOGGLE_THRESHOLD) @(posedge clk_50mhz);
        #1;
        #1;

        check_outputs(0);
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
        input expected_clk_1hz;
        begin
            if (expected_clk_1hz === (expected_clk_1hz ^ clk_1hz ^ expected_clk_1hz)) begin
                $display("PASS");
                $display("  Outputs: clk_1hz=%b",
                         clk_1hz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1hz=%b",
                         expected_clk_1hz);
                $display("  Got:      clk_1hz=%b",
                         clk_1hz);
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
        $dumpvars(0,clk_50mhz, clk_1hz);
    end

endmodule
