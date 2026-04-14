`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
        A = 4'd0; B = 4'd0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple Addition (5 + 3)", test_num);
        A = 4'd5; B = 4'd3;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Max Sum No Carry (7 + 8)", test_num);
        A = 4'd7; B = 4'd8;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Minimum Carry (8 + 8)", test_num);
        A = 4'd8; B = 4'd8;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Max Input + 1 (15 + 1)", test_num);
        A = 4'd15; B = 4'd1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Max Inputs (15 + 15)", test_num);
        A = 4'd15; B = 4'd15;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Carry with Remainder (10 + 7)", test_num);
        A = 4'd10; B = 4'd7;
        #1;

        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Pattern Check (10 + 5)", test_num);
        A = 4'b1010; B = 4'b0101;
        #1;

        check_outputs(1'b0, 4'b1111);
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
        input expected_C;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
