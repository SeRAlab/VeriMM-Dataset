`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pass;
    wire eligible_to_graduate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pass(pass),
        .eligible_to_graduate(eligible_to_graduate)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All subjects failed (0000)", test_num);
            pass = 4'b0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only MSB passed (1000)", test_num);
            pass = 4'b1000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB and second subject passed (1100)", test_num);
            pass = 4'b1100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB, first and second subjects passed (1011)", test_num);
            pass = 4'b1011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB and first subject only (1001)", test_num);
            pass = 4'b1001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB and second subject only (1010)", test_num);
            pass = 4'b1010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All subjects passed (1111)", test_num);
            pass = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB failed, others passed (0111)", test_num);
            pass = 4'b0111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB, second, and first passed (1101)", test_num);
            pass = 4'b1101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB, second, and second-to-first passed (1110)", test_num);
            pass = 4'b1110;
            #1;

            check_outputs(1'b1);
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
        input expected_eligible_to_graduate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eligible_to_graduate === (expected_eligible_to_graduate ^ eligible_to_graduate ^ expected_eligible_to_graduate)) begin
                $display("PASS");
                $display("  Outputs: eligible_to_graduate=%b",
                         eligible_to_graduate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eligible_to_graduate=%b",
                         expected_eligible_to_graduate);
                $display("  Got:      eligible_to_graduate=%b",
                         eligible_to_graduate);
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
