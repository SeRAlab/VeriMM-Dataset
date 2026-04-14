`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg flap;
    reg resetLow;
    wire flapStateEnabled;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .flap(flap),
        .resetLow(resetLow),
        .flapStateEnabled(flapStateEnabled)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetLow = 0;
            flap = 1;
            @(posedge clk);
            #1;
            resetLow = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Reset State (flapStateWait)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition to flapState (Enabled) when flap=0", test_num);
            reset_dut();
            flap = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition back to flapStateWait (Disabled) when flap=1", test_num);
            reset_dut();

            flap = 0;
            @(posedge clk);
            #1;

            flap = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ensure state stays in flapState while flap=0", test_num);
            reset_dut();
            flap = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset priority over flap signal", test_num);
            reset_dut();
            flap = 0;
            @(posedge clk);
            #1;
            resetLow = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_flapStateEnabled;
        begin
            if (expected_flapStateEnabled === (expected_flapStateEnabled ^ flapStateEnabled ^ expected_flapStateEnabled)) begin
                $display("PASS");
                $display("  Outputs: flapStateEnabled=%b",
                         flapStateEnabled);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flapStateEnabled=%b",
                         expected_flapStateEnabled);
                $display("  Got:      flapStateEnabled=%b",
                         flapStateEnabled);
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
        $dumpvars(0,clk, flap, resetLow, flapStateEnabled);
    end

endmodule
