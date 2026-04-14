`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] clk_speed_select;
    reg rst_pad_i;
    reg wb_clk;
    wire adc_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_speed_select(clk_speed_select),
        .rst_pad_i(rst_pad_i),
        .wb_clk(wb_clk),
        .adc_clk(adc_clk)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk = 0;
        forever #5 wb_clk = ~wb_clk;
    end

        task reset_dut;

        begin
            rst_pad_i = 1;
            clk_speed_select = 3'b000;
            repeat(2) @(posedge wb_clk);
            #1 rst_pad_i = 0;
            repeat(1) @(posedge wb_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Speed Select 0", test_num);
            reset_dut();
            clk_speed_select = 3'b000;

            repeat(2) @(posedge wb_clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Speed Select 1", test_num);
            reset_dut();
            clk_speed_select = 3'b001;
            repeat(4) @(posedge wb_clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Speed Select 3", test_num);
            reset_dut();
            clk_speed_select = 3'b011;
            repeat(8) @(posedge wb_clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Speed Select 7", test_num);
            reset_dut();
            clk_speed_select = 3'b111;

            repeat(2) @(posedge wb_clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset Verification", test_num);

            clk_speed_select = 3'b000;
            repeat(10) @(posedge wb_clk);

            rst_pad_i = 1;
            repeat(2) @(posedge wb_clk);
            #1 #1;
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
        input expected_adc_clk;
        begin
            if (expected_adc_clk === (expected_adc_clk ^ adc_clk ^ expected_adc_clk)) begin
                $display("PASS");
                $display("  Outputs: adc_clk=%b",
                         adc_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_clk=%b",
                         expected_adc_clk);
                $display("  Got:      adc_clk=%b",
                         adc_clk);
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
        $dumpvars(0,clk_speed_select, rst_pad_i, wb_clk, adc_clk);
    end

endmodule
