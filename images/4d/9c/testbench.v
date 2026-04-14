`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p;
    reg [3:0] q;
    wire Q3;
    wire Q4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .Q3(Q3),
        .Q4(Q4)
    );
    task testcase001;

        begin
            test_num = 1;
            p = 0; q = 4'b0001;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            p = 1; q = 4'b0001;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            p = 0; q = 4'b0010;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            p = 1; q = 4'b0010;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            p = 0; q = 4'b0100;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            p = 1; q = 4'b0100;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            p = 0; q = 4'b1000;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            p = 1; q = 4'b1000;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            p = 1; q = 4'b0000;
            #1;

            check_outputs(0, 0);
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
        input expected_Q3;
        input expected_Q4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3) &&
                expected_Q4 === (expected_Q4 ^ Q4 ^ expected_Q4)) begin
                $display("PASS");
                $display("  Outputs: Q3=%b, Q4=%b",
                         Q3, Q4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q3=%b, Q4=%b",
                         expected_Q3, expected_Q4);
                $display("  Got:      Q3=%b, Q4=%b",
                         Q3, Q4);
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
