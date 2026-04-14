`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_i;
    reg rst_i;
    wire wb_clk_o;
    wire wb_rst_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .wb_clk_o(wb_clk_o),
        .wb_rst_o(wb_rst_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset Asserted, Clock Low", test_num);

        clk_i = 1'b0;
        rst_i = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Reset Asserted, Clock High", test_num);

        clk_i = 1'b1;
        rst_i = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Reset Deasserted, Clock Low", test_num);

        clk_i = 1'b0;
        rst_i = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Reset Deasserted, Clock High", test_num);

        clk_i = 1'b1;
        rst_i = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Dynamic transition check", test_num);

        rst_i = 1'b1;
        clk_i = 1'b0;
        #10;
        rst_i = 1'b0;
        #10;
        clk_i = 1'b1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0);
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
        input expected_wb_clk_o;
        input expected_wb_rst_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wb_clk_o === (expected_wb_clk_o ^ wb_clk_o ^ expected_wb_clk_o) &&
                expected_wb_rst_o === (expected_wb_rst_o ^ wb_rst_o ^ expected_wb_rst_o)) begin
                $display("PASS");
                $display("  Outputs: wb_clk_o=%b, wb_rst_o=%b",
                         wb_clk_o, wb_rst_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_clk_o=%b, wb_rst_o=%b",
                         expected_wb_clk_o, expected_wb_rst_o);
                $display("  Got:      wb_clk_o=%b, wb_rst_o=%b",
                         wb_clk_o, wb_rst_o);
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
