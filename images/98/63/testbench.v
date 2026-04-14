`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [12:0] A;
    reg [12:0] B;
    wire [12:0] Max;
    wire [12:0] Min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Max(Max),
        .Min(Min)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A high bits > B high bits", test_num);

            A = 13'h1400;
            B = 13'h0400;
            #1;

            check_outputs(A, B);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A high bits < B high bits", test_num);

            A = 13'h0200;
            B = 13'h1E00;
            #1;

            check_outputs(B, A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High bits equal (A[12:5] == B[12:5])", test_num);


            A = 13'h0021;
            B = 13'h003F;
            #1;

            check_outputs(13'h0021, 13'h003F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary - Maximum vs Minimum possible values", test_num);
            A = 13'h1FFF;
            B = 13'h0000;
            #1;

            check_outputs(A, B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary - Minimum vs Maximum possible values", test_num);
            A = 13'h0000;
            B = 13'h1FFF;
            #1;

            check_outputs(B, A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High bits differ by 1 bit at bit 5", test_num);
            A = 13'h0020;
            B = 13'h001F;
            #1;

            check_outputs(A, B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High bits equal, all ones", test_num);
            A = 13'h1FE0;
            B = 13'h1FFF;

            #1;


            check_outputs(A, B);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A and B identical", test_num);
            A = 13'h0ABC;
            B = 13'h0ABC;
            #1;

            check_outputs(A, B);
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
        input [12:0] expected_Max;
        input [12:0] expected_Min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Max === (expected_Max ^ Max ^ expected_Max) &&
                expected_Min === (expected_Min ^ Min ^ expected_Min)) begin
                $display("PASS");
                $display("  Outputs: Max=%h, Min=%h",
                         Max, Min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Max=%h, Min=%h",
                         expected_Max, expected_Min);
                $display("  Got:      Max=%h, Min=%h",
                         Max, Min);
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
