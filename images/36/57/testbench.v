`timescale 1ns/1ps

module Comparator16Bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire A_equal;
    wire A_greater;
    wire A_less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Comparator16Bit dut (
        .A(A),
        .B(B),
        .A_equal(A_equal),
        .A_greater(A_greater),
        .A_less(A_less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0, B = 0 (Equal)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = FFFF, B = FFFF (Equal)", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = FFFF, B = 0000 (Greater)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0000, B = FFFF (Less)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 8000, B = 7FFF (Greater)", test_num);
            A = 16'h8000;
            B = 16'h7FFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 7FFF, B = 8000 (Less)", test_num);
            A = 16'h7FFF;
            B = 16'h8000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0001, B = 0000 (Greater)", test_num);
            A = 16'h0001;
            B = 16'h0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0000, B = 0001 (Less)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = A5A5, B = A5A5 (Equal)", test_num);
            A = 16'hA5A5;
            B = 16'hA5A5;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 1234, B = 1230 (Greater)", test_num);
            A = 16'h1234;
            B = 16'h1230;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = BBBB, B = CCCC (Less)", test_num);
            A = 16'hBBBB;
            B = 16'hCCCC;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = AAAA, B = 5555 (Greater)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Comparator16Bit Testbench");
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
        input expected_A_equal;
        input expected_A_greater;
        input expected_A_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_equal === (expected_A_equal ^ A_equal ^ expected_A_equal) &&
                expected_A_greater === (expected_A_greater ^ A_greater ^ expected_A_greater) &&
                expected_A_less === (expected_A_less ^ A_less ^ expected_A_less)) begin
                $display("PASS");
                $display("  Outputs: A_equal=%b, A_greater=%b, A_less=%b",
                         A_equal, A_greater, A_less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_equal=%b, A_greater=%b, A_less=%b",
                         expected_A_equal, expected_A_greater, expected_A_less);
                $display("  Got:      A_equal=%b, A_greater=%b, A_less=%b",
                         A_equal, A_greater, A_less);
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
