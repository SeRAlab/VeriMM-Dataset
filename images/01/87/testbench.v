`timescale 1ns/1ps

module Adder64Bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire Overflow;
    wire [63:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder64Bit dut (
        .A(A),
        .B(B),
        .Overflow(Overflow),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition", test_num);
            A = 64'h0000000000000000;
            B = 64'h0000000000000000;
            #1;

            check_outputs(1'b0, 64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small numbers", test_num);
            A = 64'h0000000000000005;
            B = 64'h000000000000000A;
            #1;

            check_outputs(1'b0, 64'h000000000000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max A + Zero", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000000;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near Overflow Threshold", test_num);
            A = 64'hFFFFFFFFFFFFFFFE;
            B = 64'h0000000000000001;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Boundary (Result = 2^64)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Possible Addition", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Carry Overflow", test_num);
            A = 64'h8000000000000000;
            B = 64'h8000000000000000;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Addition (AA + 55)", test_num);
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'h5555555555555555;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Value Sum", test_num);
            A = 64'h123456789ABCDEF0;
            B = 64'h1111111111111111;
            #1;

            check_outputs(1'b0, 64'h23456789BCDEF001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Value Overflow", test_num);
            A = 64'hF0F0F0F0F0F0F0F0;
            B = 64'hF0F0F0F0F0F0F0F0;
            #1;

            check_outputs(1'b1, 64'hE1E1E1E1E1E1E1E0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder64Bit Testbench");
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
        input expected_Overflow;
        input [63:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Overflow=%b, Sum=%h",
                         Overflow, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Overflow=%b, Sum=%h",
                         expected_Overflow, expected_Sum);
                $display("  Got:      Overflow=%b, Sum=%h",
                         Overflow, Sum);
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
