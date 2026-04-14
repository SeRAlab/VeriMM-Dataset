`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .parity(parity)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 0; in2 = 0; in3 = 0; in4 = 0;
            $display("Test Case %03d: All inputs LOW", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 0; in2 = 0; in3 = 0; in4 = 1;
            $display("Test Case %03d: One input HIGH (in4)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 0; in2 = 1; in3 = 0; in4 = 0;
            $display("Test Case %03d: One input HIGH (in2)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 1; in2 = 1; in3 = 0; in4 = 0;
            $display("Test Case %03d: Two inputs HIGH (in1, in2)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 1; in2 = 0; in3 = 0; in4 = 1;
            $display("Test Case %03d: Two inputs HIGH (in1, in4)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 1; in2 = 1; in3 = 1; in4 = 0;
            $display("Test Case %03d: Three inputs HIGH (in1, in2, in3)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 0; in2 = 1; in3 = 1; in4 = 1;
            $display("Test Case %03d: Three inputs HIGH (in2, in3, in4)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in1 = 1; in2 = 1; in3 = 1; in4 = 1;
            $display("Test Case %03d: All four inputs HIGH", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in1 = 1; in2 = 0; in3 = 1; in4 = 0;
            $display("Test Case %03d: Alternating HIGH/LOW", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in1 = 0; in2 = 0; in3 = 1; in4 = 0;
            $display("Test Case %03d: One input HIGH (in3)", test_num);
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
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
