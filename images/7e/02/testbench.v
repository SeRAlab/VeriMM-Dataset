`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg wb_clk_i;
    reg wb_rst_i;
    reg wb_tgc_i;
    wire wb_tgc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_tgc_i(wb_tgc_i),
        .wb_tgc_o(wb_tgc_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            wb_tgc_i = 0;
            @(posedge wb_clk_i);
            #2 wb_rst_i = 0;
            $display("DUT Reset at time %0t", $time);
            @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle High (wb_tgc_i = 0)", test_num);
            reset_dut();
            wb_tgc_i = 0;



            repeat(131072) @(posedge wb_clk_i);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Inhibit Toggle (wb_tgc_i = 1)", test_num);
            reset_dut();
            wb_tgc_i = 1;


            repeat(131072) @(posedge wb_clk_i);

            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle Low (Sequential Toggles)", test_num);
            reset_dut();
            wb_tgc_i = 0;


            repeat(131072) @(posedge wb_clk_i);
            #2;
            if (wb_tgc_o !== 1'b1) $display("Error: Failed to toggle High at first edge.");



            repeat(262144) @(posedge wb_clk_i);
            #2;
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
        input expected_wb_tgc_o;
        begin
            if (expected_wb_tgc_o === (expected_wb_tgc_o ^ wb_tgc_o ^ expected_wb_tgc_o)) begin
                $display("PASS");
                $display("  Outputs: wb_tgc_o=%b",
                         wb_tgc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_tgc_o=%b",
                         expected_wb_tgc_o);
                $display("  Got:      wb_tgc_o=%b",
                         wb_tgc_o);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,wb_clk_i, wb_rst_i, wb_tgc_i, wb_tgc_o);
    end

endmodule
