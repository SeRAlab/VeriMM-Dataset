`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [16:0] a;
    reg [16:0] b;
    wire [16:0] ab;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ab(ab)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Multiplication (0 * 0)", test_num);
            a = 17'h00000;
            b = 17'h00000;
            #1;

            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Identity-like (Max * Max)", test_num);

            a = 17'h0FFFF;
            b = 17'h0FFFF;
            #1;

            check_outputs(17'h0FFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Half Magnitude (0.5 * 0.5)", test_num);

            a = 17'h08000;
            b = 17'h08000;
            #1;

            check_outputs(17'h04000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive * Negative", test_num);



            a = 17'h08000;
            b = 17'h18000;
            #1;

            check_outputs(17'h14000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative * Positive", test_num);


            a = 17'h1FFFF;
            b = 17'h00001;
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative * Negative", test_num);


            a = 17'h18000;
            b = 17'h18000;
            #1;

            check_outputs(17'h04000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow / Small values", test_num);

            a = 17'h000FF;
            b = 17'h000FF;
            #1;

            check_outputs(17'h00000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative * Negative Max", test_num);


            a = 17'h1FFFF;
            b = 17'h1FFFF;
            #1;

            check_outputs(17'h0FFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Magnitude Negative", test_num);
            a = 17'h10000;
            b = 17'h0FFFF;
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Values", test_num);


            a = 17'h01234;
            b = 17'h05678;
            #1;

            check_outputs(17'h00626);
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
        input [16:0] expected_ab;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ab === (expected_ab ^ ab ^ expected_ab)) begin
                $display("PASS");
                $display("  Outputs: ab=%h",
                         ab);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ab=%h",
                         expected_ab);
                $display("  Got:      ab=%h",
                         ab);
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
