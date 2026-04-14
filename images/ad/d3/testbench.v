`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    wire gated_clock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .gated_clock(gated_clock)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable = 0;
            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            enable = 1;

            @(posedge clock);
            #2;
            $display("Test %0d: Enable=1, Clock=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            enable = 1;

            @(negedge clock);
            #2;
            $display("Test %0d: Enable=1, Clock=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            enable = 0;

            @(posedge clock);
            #2;
            $display("Test %0d: Enable=0, Clock=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            enable = 0;

            @(negedge clock);
            #2;
            $display("Test %0d: Enable=0, Clock=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            enable = 0;
            @(negedge clock);
            #1;
            enable = 1;
            @(posedge clock);
            #2;
            $display("Test %0d: Transition Low->High, Clock=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            enable = 1;
            @(negedge clock);
            #1;
            enable = 0;
            @(posedge clock);
            #2;
            $display("Test %0d: Transition High->Low, Clock=1", test_num);
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
        testcase006();
        
        
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
        input expected_gated_clock;
        begin
            if (expected_gated_clock === (expected_gated_clock ^ gated_clock ^ expected_gated_clock)) begin
                $display("PASS");
                $display("  Outputs: gated_clock=%b",
                         gated_clock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_clock=%b",
                         expected_gated_clock);
                $display("  Got:      gated_clock=%b",
                         gated_clock);
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
        $dumpvars(0,clock, enable, gated_clock);
    end

endmodule
