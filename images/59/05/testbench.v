`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg carry_in;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .carry_in(carry_in),
        .Sum(Sum)
    );
    task set_inputs;

        input [2:0] in_A;
        input [2:0] in_B;
        input in_cin;
        begin
            test_num = test_num + 1;
            A = in_A;
            B = in_B;
            carry_in = in_cin;
        end
        endtask

    task testcase001;

    begin
        set_inputs(3'sb001, 3'sb001, 1'b0);
        #1;

        check_outputs(4'sb0010);
    end
        endtask

    task testcase002;

    begin
        set_inputs(3'sb001, 3'sb001, 1'b1);
        #1;

        check_outputs(4'sb0011);
    end
        endtask

    task testcase003;

    begin
        set_inputs(3'sb011, 3'sb011, 1'b1);
        #1;

        check_outputs(4'sb0111);
    end
        endtask

    task testcase004;

    begin
        set_inputs(3'sb010, 3'sb111, 1'b0);
        #1;

        check_outputs(4'sb0001);
    end
        endtask

    task testcase005;

    begin
        set_inputs(3'sb010, 3'sb111, 1'b1);
        #1;

        check_outputs(4'sb0010);
    end
        endtask

    task testcase006;

    begin
        set_inputs(3'sb110, 3'sb110, 1'b0);
        #1;

        check_outputs(4'sb1100);
    end
        endtask

    task testcase007;

    begin
        set_inputs(3'sb110, 3'sb110, 1'b1);
        #1;

        check_outputs(4'sb1101);
    end
        endtask

    task testcase008;

    begin
        set_inputs(3'sb100, 3'sb100, 1'b0);
        #1;

        check_outputs(4'sb1000);
    end
        endtask

    task testcase009;

    begin
        set_inputs(3'sb100, 3'sb100, 1'b1);
        #1;

        check_outputs(4'sb1001);
    end
        endtask

    task testcase010;

    begin
        set_inputs(3'sb000, 3'sb000, 1'b0);
        #1;

        check_outputs(4'sb0000);
    end
        endtask

    task testcase011;

    begin
        set_inputs(3'sb000, 3'sb000, 1'b1);
        #1;

        check_outputs(4'sb0001);
    end
        endtask

    task testcase012;

    begin
        set_inputs(3'sb100, 3'sb011, 1'b1);
        #1;

        check_outputs(4'sb0000);
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
