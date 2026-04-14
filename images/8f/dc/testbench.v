`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_i;
    reg en_i;
    reg test_en_i;
    wire clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .en_i(en_i),
        .test_en_i(test_en_i),
        .clk_o(clk_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Enable signals LOW", test_num);

            clk_i = 0; en_i = 0; test_en_i = 0;
            #10;

            clk_i = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: en_i HIGH, test_en_i LOW", test_num);

            clk_i = 0; en_i = 0; test_en_i = 0;
            #10;

            en_i = 1;
            #10;

            clk_i = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: en_i LOW, test_en_i HIGH", test_num);

            clk_i = 0; en_i = 0; test_en_i = 0;
            #10;

            test_en_i = 1;
            #10;

            clk_i = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition from Enabled to Gated", test_num);

            clk_i = 0; en_i = 1; test_en_i = 0;
            #10;
            clk_i = 1; #10;


            clk_i = 0;
            en_i = 0;
            #10;


            clk_i = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable HIGH during clk_i HIGH phase (Latch check)", test_num);

            clk_i = 0; en_i = 0; test_en_i = 0;
            #10;


            clk_i = 1;
            #5;


            en_i = 1;
            #5;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Both en_i and test_en_i HIGH", test_num);

            clk_i = 0; en_i = 0; test_en_i = 0;
            #10;

            en_i = 1; test_en_i = 1;
            #10;

            clk_i = 1;
            #10;
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
        input expected_clk_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_o === (expected_clk_o ^ clk_o ^ expected_clk_o)) begin
                $display("PASS");
                $display("  Outputs: clk_o=%b",
                         clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_o=%b",
                         expected_clk_o);
                $display("  Got:      clk_o=%b",
                         clk_o);
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
