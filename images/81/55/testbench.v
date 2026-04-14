`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg x;
    reg y;
    wire state;
    wire t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x(x),
        .y(y),
        .state(state),
        .t(t)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            x = 0;
            y = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset (x=0, y=1) -> state=0");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Set (x=1, y=1) -> state=1");
            test_num = 2;
            reset_dut();
            x = 1; y = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold (x=1, y=0) from state 1 -> state=1");
            test_num = 3;
            reset_dut();
            x = 1; y = 1; @(posedge clk);
            x = 1; y = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold (x=1, y=0) from state 0 -> state=0");
            test_num = 4;
            reset_dut();
            x = 1; y = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Toggle (x=0, y=0) from state 1 -> state=0");
            test_num = 5;
            reset_dut();
            x = 1; y = 1; @(posedge clk);
            x = 0; y = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Toggle (x=0, y=0) from state 0 -> state=1");
            test_num = 6;
            reset_dut();
            x = 0; y = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset (x=0, y=1) from state 0 -> state=0");
            test_num = 7;
            reset_dut();
            x = 0; y = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Sequence Set -> Hold -> Toggle -> Reset");
            test_num = 8;
            reset_dut();
            x = 1; y = 1; @(posedge clk);
            x = 1; y = 0; @(posedge clk);
            x = 0; y = 0; @(posedge clk);
            x = 0; y = 1; @(posedge clk);
            #1;
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_state;
        input expected_t;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: state=%b, t=%b",
                         state, t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%b, t=%b",
                         expected_state, expected_t);
                $display("  Got:      state=%b, t=%b",
                         state, t);
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
        $dumpvars(0,clk, x, y, state, t);
    end

endmodule
