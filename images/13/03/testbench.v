`timescale 1ns/1ps

module Adder_5bit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [5:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder_5bit dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: 0 + 0", test_num);
        A = 5'd0;
        B = 5'd0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: 31 + 31", test_num);
        A = 5'd31;
        B = 5'd31;
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: 10 + 5", test_num);
        A = 5'd10;
        B = 5'd5;
        #1;

        check_outputs(6'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: 16 + 16", test_num);
        A = 5'd16;
        B = 5'd16;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: 31 + 1", test_num);
        A = 5'd31;
        B = 5'd1;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: 25 + 10", test_num);
        A = 5'd25;
        B = 5'd10;
        #1;

        check_outputs(6'd35);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: 0 + 31", test_num);
        A = 5'd0;
        B = 5'd31;
        #1;

        check_outputs(6'd31);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder_5bit Testbench");
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
        input [5:0] expected_Sum;
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
