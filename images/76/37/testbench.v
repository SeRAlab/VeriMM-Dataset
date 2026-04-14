`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg enable;
    wire gated_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .gated_clk(gated_clk)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable LOW, Clock LOW", test_num);
            enable = 0;
            clk = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable LOW, Clock HIGH", test_num);
            enable = 0;
            clk = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable HIGH, Clock LOW", test_num);
            enable = 1;
            clk = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable HIGH, Clock HIGH", test_num);
            enable = 1;
            clk = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Falling Edge while Clock is HIGH", test_num);

            clk = 1;
            enable = 1;
            #5;

            enable = 0;
            #5;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Rising Edge while Clock is HIGH", test_num);

            clk = 1;
            enable = 0;
            #5;

            enable = 1;
            #5;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Clock while Enabled", test_num);
            enable = 1;
            clk = 0; #5;
            clk = 1; #5;
            clk = 0; #5;
            clk = 1; #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Clock while Disabled", test_num);
            enable = 0;
            clk = 0; #5;
            clk = 1; #5;
            clk = 0; #5;
            clk = 1; #5;
            #1;

            check_outputs(1'b0);
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
        input expected_gated_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gated_clk === (expected_gated_clk ^ gated_clk ^ expected_gated_clk)) begin
                $display("PASS");
                $display("  Outputs: gated_clk=%b",
                         gated_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_clk=%b",
                         expected_gated_clk);
                $display("  Got:      gated_clk=%b",
                         gated_clk);
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
