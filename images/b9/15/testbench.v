`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [3:0] signal_in;
    wire [3:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Buffer Disabled (High-Impedance Check)", test_num);
            ctrl = 1'b0;
            signal_in = 4'b1010;
            #10;
            #1;

            check_outputs(4'bzzzz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Buffer Enabled - Pattern 1010", test_num);
            ctrl = 1'b1;
            signal_in = 4'b1010;
            #10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Buffer Enabled - Pattern 0101", test_num);
            ctrl = 1'b1;
            signal_in = 4'b0101;
            #10;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Buffer Enabled - Pattern 1111", test_num);
            ctrl = 1'b1;
            signal_in = 4'b1111;
            #10;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Buffer Enabled - Pattern 0000", test_num);
            ctrl = 1'b1;
            signal_in = 4'b0000;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Buffer Disabled - Input Change to 1111", test_num);
            ctrl = 1'b0;
            signal_in = 4'b1111;
            #10;
            #1;

            check_outputs(4'bzzzz);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Buffer Disabled - Input Change to 0000", test_num);
            ctrl = 1'b0;
            signal_in = 4'b0000;
            #10;
            #1;

            check_outputs(4'bzzzz);
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
        input [3:0] expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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

endmodule
