`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg b;
    reg clock;
    wire x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .clock(clock),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            b = 0;

            @(negedge clock);
            #2;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            b = 1;
            #2;
            $display("Testcase %0d: Testing x transparency (clock=1, b:0->1)", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            #5;
            b = 1;
            #2;
            $display("Testcase %0d: Testing y transparency (clock=0, b:0->1)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            b = 1;
            #2;

            #3;

            b = 0;
            #2;
            $display("Testcase %0d: Testing x hold (clock:1->0, b:1->0)", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            #5;
            b = 1;
            #2;

            #3;

            b = 0;
            #2;
            $display("Testcase %0d: Testing y hold (clock:0->1, b:1->0)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            b = 1;
            #15;
            $display("Testcase %0d: Testing both outputs high", test_num);
            #1;

            check_outputs(1, 1);
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
        input expected_x;
        input expected_y;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%b, y=%b",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%b, y=%b",
                         expected_x, expected_y);
                $display("  Got:      x=%b, y=%b",
                         x, y);
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
        $dumpvars(0,b, clock, x, y);
    end

endmodule
