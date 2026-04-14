`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] num;
    wire [31:0] fact;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .fact(fact)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: num = 0 (Factorial of 0 is 1)", test_num);
            num = 16'd0;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: num = 1 (Factorial of 1 is 1)", test_num);
            num = 16'd1;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: num = 2 (Factorial of 2 is 2)", test_num);
            num = 16'd2;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: num = 5 (Factorial of 5 is 120)", test_num);
            num = 16'd5;
            #1;

            check_outputs(32'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: num = 8 (Factorial of 8 is 40320)", test_num);
            num = 16'd8;
            #1;

            check_outputs(32'd40320);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: num = 10 (Factorial of 10 is 3628800)", test_num);
            num = 16'd10;
            #1;

            check_outputs(32'd3628800);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: num = 12 (Factorial of 12 is 479001600)", test_num);
            num = 16'd12;
            #1;

            check_outputs(32'd479001600);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: num = 13 (Factorial of 13 overflows 32-bit, checking lower bits)", test_num);
            num = 16'd13;

            #1;


            check_outputs(32'h7328CC00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: num = 15 (Max in-range input, checking lower bits)", test_num);
            num = 16'd15;

            #1;


            check_outputs(32'h77792000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: num = 16 (Outside range, expected 0)", test_num);
            num = 16'd16;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: num = 1000 (Far outside range, expected 0)", test_num);
            num = 16'd1000;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: num = 65535 (Max input value, expected 0)", test_num);
            num = 16'hFFFF;
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_fact;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fact === (expected_fact ^ fact ^ expected_fact)) begin
                $display("PASS");
                $display("  Outputs: fact=%h",
                         fact);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fact=%h",
                         expected_fact);
                $display("  Got:      fact=%h",
                         fact);
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
