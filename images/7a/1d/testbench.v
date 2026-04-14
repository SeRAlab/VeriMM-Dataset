`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg S_select;
    wire Cout;
    wire [3:0] S_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S_select(S_select),
        .Cout(Cout),
        .S_out(S_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Simple addition (2 + 3)", test_num);
        A = 4'd2;
        B = 4'd3;
        S_select = 1'b0;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition with carry (15 + 1)", test_num);
        A = 4'd15;
        B = 4'd1;
        S_select = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Addition with zero (0 + 0)", test_num);
        A = 4'd0;
        B = 4'd0;
        S_select = 1'b0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Simple subtraction (10 - 4)", test_num);
        A = 4'd10;
        B = 4'd4;
        S_select = 1'b1;
        #1;

        check_outputs(1'b0, 4'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Subtraction with borrow (4 - 10)", test_num);
        A = 4'd4;
        B = 4'd10;
        S_select = 1'b1;

        #1;


        check_outputs(1'b1, 4'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Subtraction resulting in zero (7 - 7)", test_num);
        A = 4'd7;
        B = 4'd7;
        S_select = 1'b1;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Max values addition (15 + 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        S_select = 1'b0;

        #1;


        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Subtraction from zero (0 - 1)", test_num);
        A = 4'd0;
        B = 4'd1;
        S_select = 1'b1;

        #1;


        check_outputs(1'b1, 4'd15);
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
        input expected_Cout;
        input [3:0] expected_S_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S_out === (expected_S_out ^ S_out ^ expected_S_out)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S_out=%h",
                         Cout, S_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S_out=%h",
                         expected_Cout, expected_S_out);
                $display("  Got:      Cout=%b, S_out=%h",
                         Cout, S_out);
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
