`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] B;
    wire [15:0] shift_left;
    wire [15:0] shift_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .shift_left(shift_left),
        .shift_right(shift_right)
    );
    task testcase001;

        begin
            A = 16'hABCD;
            B = 4'd0;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            A = 16'h1234;
            B = 4'd1;
            #1;

            check_outputs(16'h2468, 16'h091A);
        end
        endtask

    task testcase003;

        begin
            A = 16'hF0F0;
            B = 4'd4;
            #1;

            check_outputs(16'h0F00, 16'h0F0F);
        end
        endtask

    task testcase004;

        begin
            A = 16'h1234;
            B = 4'd8;
            #1;

            check_outputs(16'h3400, 16'h0012);
        end
        endtask

    task testcase005;

        begin
            A = 16'h8001;
            B = 4'd15;
            #1;

            check_outputs(16'h8000, 16'h0001);
        end
        endtask

    task testcase006;

        begin
            A = 16'hFFFF;
            B = 4'd4;
            #1;

            check_outputs(16'hFFF0, 16'h0FFF);
        end
        endtask

    task testcase007;

        begin
            A = 16'h0000;
            B = 4'd5;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            A = 16'hAAAA;
            B = 4'd1;
            #1;

            check_outputs(16'h5554, 16'h5555);
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
        input [15:0] expected_shift_left;
        input [15:0] expected_shift_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shift_left === (expected_shift_left ^ shift_left ^ expected_shift_left) &&
                expected_shift_right === (expected_shift_right ^ shift_right ^ expected_shift_right)) begin
                $display("PASS");
                $display("  Outputs: shift_left=%h, shift_right=%h",
                         shift_left, shift_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_left=%h, shift_right=%h",
                         expected_shift_left, expected_shift_right);
                $display("  Got:      shift_left=%h, shift_right=%h",
                         shift_left, shift_right);
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
