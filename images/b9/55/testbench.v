`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] shifted_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .shifted_value(shifted_value)
    );
    task testcase001;

        begin
            $display("Running testcase001: Left Shift (A=0001, B=1, C=0)");
            A = 4'b0001; B = 4'd1; C = 1'b0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Left Shift (A=1011, B=2, C=0)");
            A = 4'b1011; B = 4'd2; C = 1'b0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Left Shift Zero (A=1111, B=0, C=0)");
            A = 4'b1111; B = 4'd0; C = 1'b0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Left Shift Overflow (A=1111, B=4, C=0)");
            A = 4'b1111; B = 4'd4; C = 1'b0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Right Shift (A=1000, B=1, C=1)");
            A = 4'b1000; B = 4'd1; C = 1'b1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Right Shift (A=1101, B=2, C=1)");
            A = 4'b1101; B = 4'd2; C = 1'b1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Right Shift Zero (A=1010, B=0, C=1)");
            A = 4'b1010; B = 4'd0; C = 1'b1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Right Shift Overflow (A=1111, B=4, C=1)");
            A = 4'b1111; B = 4'd4; C = 1'b1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Left Shift Large B (A=1111, B=8, C=0)");
            A = 4'b1111; B = 4'd8; C = 1'b0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Shift Zero Value (A=0000, B=2, C=0)");
            A = 4'b0000; B = 4'd2; C = 1'b0;
            #1;

            check_outputs(4'b0000);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_shifted_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_value === (expected_shifted_value ^ shifted_value ^ expected_shifted_value)) begin
                $display("PASS");
                $display("  Outputs: shifted_value=%h",
                         shifted_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_value=%h",
                         expected_shifted_value);
                $display("  Got:      shifted_value=%h",
                         shifted_value);
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
