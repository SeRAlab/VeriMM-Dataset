`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [3:0] B;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input A=0", test_num);
        A = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input A=7", test_num);
        A = 4'd7;
        #1;

        check_outputs(4'd0, 4'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input A=9", test_num);
        A = 4'd9;
        #1;

        check_outputs(4'd0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input A=10", test_num);
        A = 4'd10;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input A=13", test_num);
        A = 4'd13;
        #1;

        check_outputs(4'd1, 4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input A=15", test_num);
        A = 4'd15;
        #1;

        check_outputs(4'd1, 4'd5);
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
        input [3:0] expected_B;
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: B=%h, C=%h",
                         B, C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, C=%h",
                         expected_B, expected_C);
                $display("  Got:      B=%h, C=%h",
                         B, C);
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
