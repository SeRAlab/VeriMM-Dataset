`timescale 1ns/1ps

module yet_new_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg x;
    wire w;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    yet_new_module dut (
        .clock(clock),
        .x(x),
        .w(w),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            x = 0;
            @(posedge clock);
            @(negedge clock);
            #1;
            $display("DUT Reset: w=%b, y=%b", w, y);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Following Specification Waveform", test_num);
            reset_dut();

            @(posedge clock) x = 1;
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Posedge Toggle (x=1)", test_num);
            reset_dut();
            @(posedge clock) x = 1;
            @(negedge clock) x = 1;
            @(posedge clock) x = 1;
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Negedge Toggle (x=0)", test_num);
            reset_dut();
            @(posedge clock) x = 0;
            @(negedge clock) x = 0;
            @(posedge clock) x = 0;
            @(negedge clock) x = 0;
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Mixed Input Sequence", test_num);
            reset_dut();
            @(posedge clock) x = 0;
            @(negedge clock) x = 1;
            @(posedge clock) x = 1;
            @(negedge clock) x = 1;
            @(posedge clock) x = 0;
            @(negedge clock) x = 0;
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("yet_new_module Testbench");
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
        input expected_w;
        input expected_y;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w=%b, y=%b",
                         w, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b, y=%b",
                         expected_w, expected_y);
                $display("  Got:      w=%b, y=%b",
                         w, y);
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
        $dumpvars(0,clock, x, w, y);
    end

endmodule
