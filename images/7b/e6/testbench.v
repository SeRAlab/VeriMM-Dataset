`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg free_clk;
    reg func_en;
    reg gating_override;
    reg pwr_en;
    wire gated_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .free_clk(free_clk),
        .func_en(func_en),
        .gating_override(gating_override),
        .pwr_en(pwr_en),
        .gated_clk(gated_clk)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Gating Override Mode", test_num);

            free_clk = 0; func_en = 0; pwr_en = 0; gating_override = 0;
            #10;

            gating_override = 1;
            #10;
            free_clk = 1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Functional and Power Enabled", test_num);

            free_clk = 0; func_en = 0; pwr_en = 0; gating_override = 0;
            #10;

            func_en = 1;
            pwr_en = 1;
            #10;
            free_clk = 1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Power Gating Active (pwr_en low)", test_num);

            free_clk = 0; func_en = 0; pwr_en = 0; gating_override = 0;
            #10;

            func_en = 1;
            pwr_en = 0;
            #10;
            free_clk = 1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Functional Gating Active (func_en low)", test_num);

            free_clk = 0; func_en = 0; pwr_en = 0; gating_override = 0;
            #10;

            func_en = 0;
            pwr_en = 1;
            #10;
            free_clk = 1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clock Low Phase Check", test_num);

            free_clk = 0; func_en = 0; pwr_en = 0; gating_override = 0;
            #10;

            func_en = 1;
            pwr_en = 1;
            gating_override = 1;
            #10;

            free_clk = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Enables Disabled", test_num);

            free_clk = 0; func_en = 0; pwr_en = 0; gating_override = 0;
            #10;

            func_en = 0;
            pwr_en = 0;
            gating_override = 0;
            #10;
            free_clk = 1;

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
