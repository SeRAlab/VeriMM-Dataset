`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Q10;
    reg [5:0] Q6;
    reg clk;
    reg reset;
    wire DM_WE;
    wire RF_WE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q10(Q10),
        .Q6(Q6),
        .clk(clk),
        .reset(reset),
        .DM_WE(DM_WE),
        .RF_WE(RF_WE)
    );
    task perform_reset;

        begin
            reset = 1;
            Q10 = 0;
            Q6 = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state override", test_num);
            reset = 1;
            Q6 = 3;
            Q10 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DM_WE enabled (Q6=3)", test_num);
            perform_reset();
            Q6 = 3;
            Q10 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DM_WE disabled (Q6!=3)", test_num);
            perform_reset();
            Q6 = 4;
            Q10 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RF_WE Range 1 - Lower Bound (Q10=1)", test_num);
            perform_reset();
            Q6 = 0;
            Q10 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RF_WE Range 1 - Upper Bound (Q10=20)", test_num);
            perform_reset();
            Q6 = 0;
            Q10 = 20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RF_WE Gap (Q10=21)", test_num);
            perform_reset();
            Q6 = 0;
            Q10 = 21;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RF_WE Range 2 - Bound (Q10=23)", test_num);
            perform_reset();
            Q6 = 0;
            Q10 = 23;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RF_WE Range 2 - Bound (Q10=24)", test_num);
            perform_reset();
            Q6 = 0;
            Q10 = 24;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RF_WE Out of Range High (Q10=25)", test_num);
            perform_reset();
            Q6 = 0;
            Q10 = 25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Write Enables", test_num);
            perform_reset();
            Q6 = 3;
            Q10 = 15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1);
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
        input expected_DM_WE;
        input expected_RF_WE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DM_WE === (expected_DM_WE ^ DM_WE ^ expected_DM_WE) &&
                expected_RF_WE === (expected_RF_WE ^ RF_WE ^ expected_RF_WE)) begin
                $display("PASS");
                $display("  Outputs: DM_WE=%b, RF_WE=%b",
                         DM_WE, RF_WE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DM_WE=%b, RF_WE=%b",
                         expected_DM_WE, expected_RF_WE);
                $display("  Got:      DM_WE=%b, RF_WE=%b",
                         DM_WE, RF_WE);
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
