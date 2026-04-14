`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din_3_0_eq_0;
    reg din_3_2_eq_0;
    reg din_7_4_eq_0;
    reg din_7_6_eq_0;
    reg lead0_4b_0_hi;
    reg lead0_4b_0_lo;
    wire din_7_0_eq_0;
    wire lead0_8b_0;
    wire lead0_8b_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_3_0_eq_0(din_3_0_eq_0),
        .din_3_2_eq_0(din_3_2_eq_0),
        .din_7_4_eq_0(din_7_4_eq_0),
        .din_7_6_eq_0(din_7_6_eq_0),
        .lead0_4b_0_hi(lead0_4b_0_hi),
        .lead0_4b_0_lo(lead0_4b_0_lo),
        .din_7_0_eq_0(din_7_0_eq_0),
        .lead0_8b_0(lead0_8b_0),
        .lead0_8b_1(lead0_8b_1)
    );
    task testcase001;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 0;
            din_7_6_eq_0 = 0;
            lead0_4b_0_hi = 0;
            din_3_0_eq_0 = 0;
            din_3_2_eq_0 = 1;
            lead0_4b_0_lo = 1;
            #10;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 0;
            din_7_6_eq_0 = 0;
            lead0_4b_0_hi = 1;
            din_3_0_eq_0 = 1;
            din_3_2_eq_0 = 0;
            lead0_4b_0_lo = 0;
            #10;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 0;
            din_7_6_eq_0 = 1;
            lead0_4b_0_hi = 0;
            din_3_0_eq_0 = 0;
            din_3_2_eq_0 = 1;
            lead0_4b_0_lo = 1;
            #10;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 0;
            din_7_6_eq_0 = 1;
            lead0_4b_0_hi = 1;
            din_3_0_eq_0 = 1;
            din_3_2_eq_0 = 0;
            lead0_4b_0_lo = 0;
            #10;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 1;
            din_7_6_eq_0 = 0;
            lead0_4b_0_hi = 0;
            din_3_0_eq_0 = 0;
            din_3_2_eq_0 = 0;
            lead0_4b_0_lo = 0;
            #10;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 1;
            din_7_6_eq_0 = 1;
            lead0_4b_0_hi = 1;
            din_3_0_eq_0 = 0;
            din_3_2_eq_0 = 0;
            lead0_4b_0_lo = 1;
            #10;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 1;
            din_7_6_eq_0 = 0;
            lead0_4b_0_hi = 0;
            din_3_0_eq_0 = 0;
            din_3_2_eq_0 = 1;
            lead0_4b_0_lo = 0;
            #10;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 1;
            din_7_6_eq_0 = 1;
            lead0_4b_0_hi = 1;
            din_3_0_eq_0 = 0;
            din_3_2_eq_0 = 1;
            lead0_4b_0_lo = 1;
            #10;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase009;



        begin
            test_num = test_num + 1;
            din_7_4_eq_0 = 1;
            din_3_0_eq_0 = 1;
            din_3_2_eq_0 = 1;
            lead0_4b_0_lo = 1;
            #10;
            #1;

            check_outputs(1, 1, 1);
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
        input expected_din_7_0_eq_0;
        input expected_lead0_8b_0;
        input expected_lead0_8b_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din_7_0_eq_0 === (expected_din_7_0_eq_0 ^ din_7_0_eq_0 ^ expected_din_7_0_eq_0) &&
                expected_lead0_8b_0 === (expected_lead0_8b_0 ^ lead0_8b_0 ^ expected_lead0_8b_0) &&
                expected_lead0_8b_1 === (expected_lead0_8b_1 ^ lead0_8b_1 ^ expected_lead0_8b_1)) begin
                $display("PASS");
                $display("  Outputs: din_7_0_eq_0=%b, lead0_8b_0=%b, lead0_8b_1=%b",
                         din_7_0_eq_0, lead0_8b_0, lead0_8b_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_7_0_eq_0=%b, lead0_8b_0=%b, lead0_8b_1=%b",
                         expected_din_7_0_eq_0, expected_lead0_8b_0, expected_lead0_8b_1);
                $display("  Got:      din_7_0_eq_0=%b, lead0_8b_0=%b, lead0_8b_1=%b",
                         din_7_0_eq_0, lead0_8b_0, lead0_8b_1);
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
