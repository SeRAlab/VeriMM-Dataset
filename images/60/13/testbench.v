`timescale 1ns/1ps

module another_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg q;
    wire x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    another_module dut (
        .clock(clock),
        .q(q),
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
            q = 0;

            @(posedge clock);
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            q = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            q = 1;
            @(posedge clock);
            q = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            q = 1;
            @(posedge clock);
            q = 1;
            @(posedge clock);
            q = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            q = 1; @(posedge clock);
            q = 1; @(posedge clock);
            q = 0; @(posedge clock);
            q = 1; @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            q = 1; @(posedge clock);
            q = 0; @(posedge clock);
            q = 0; @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("another_module Testbench");
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
        $dumpvars(0,clock, q, x, y);
    end

endmodule
