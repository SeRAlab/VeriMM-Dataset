`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_in;
    reg external_en;
    reg global_en;
    reg local_en;
    reg module_en;
    reg pad_yy_icg_scan_en;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .external_en(external_en),
        .global_en(global_en),
        .local_en(local_en),
        .module_en(module_en),
        .pad_yy_icg_scan_en(pad_yy_icg_scan_en),
        .clk_out(clk_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All enables low - clock should be gated", test_num);

            clk_in = 0;
            global_en = 0;
            module_en = 0;
            local_en = 0;
            external_en = 0;
            pad_yy_icg_scan_en = 0;
            #10;


            clk_in = 1;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: pad_yy_icg_scan_en active - clock should pass", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            pad_yy_icg_scan_en = 1;
            #5;
            clk_in = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: external_en active - clock should pass", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            external_en = 1;
            #5;
            clk_in = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: global_en + module_en active - clock should pass", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            global_en = 1;
            module_en = 1;
            #5;
            clk_in = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: global_en + local_en active - clock should pass", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            global_en = 1;
            local_en = 1;
            #5;
            clk_in = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: global_en active but sub-enables low - clock should be gated", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            global_en = 1;
            module_en = 0;
            local_en = 0;
            #5;
            clk_in = 1;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: module/local active but global_en low - clock should be gated", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            global_en = 0;
            module_en = 1;
            local_en = 1;
            #5;
            clk_in = 1;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock propagation check (clk_in=0, enabled) - output should be 0", test_num);

            clk_in = 0; global_en = 0; module_en = 0; local_en = 0; external_en = 0; pad_yy_icg_scan_en = 0;
            #10;

            pad_yy_icg_scan_en = 1;
            clk_in = 0;
            #5;
            #1;

            check_outputs(0);
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
        input expected_clk_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
