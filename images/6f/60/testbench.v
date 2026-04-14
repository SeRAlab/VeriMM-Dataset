`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg ena_i;
    reg [15:0] mask_i;
    reg rst_i;
    reg strobe_i;
    wire pn_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .ena_i(ena_i),
        .mask_i(mask_i),
        .rst_i(rst_i),
        .strobe_i(strobe_i),
        .pn_o(pn_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        rst_i = 1;
        ena_i = 1;
        strobe_i = 0;
        mask_i = 16'h0000;
        @(posedge clk_i);
        #1;
        rst_i = 0;
        @(posedge clk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift 1 cycle with mask 0x0001", test_num);
        reset_dut();
        mask_i = 16'h0001;
        strobe_i = 1;
        @(posedge clk_i);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift 1 cycle with mask 0x0002", test_num);
        reset_dut();
        mask_i = 16'h0002;
        strobe_i = 1;
        @(posedge clk_i);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift 2 cycles with mask 0x0002", test_num);
        reset_dut();
        mask_i = 16'h0002;
        strobe_i = 1;
        @(posedge clk_i);
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift 2 cycles with mask 0x0003", test_num);
        reset_dut();
        mask_i = 16'h0003;
        strobe_i = 1;
        @(posedge clk_i);
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Strobe disabled check", test_num);
        reset_dut();
        mask_i = 16'hFFFF;
        strobe_i = 0;
        repeat(5) @(posedge clk_i);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable signal low (reset) check", test_num);
        reset_dut();
        mask_i = 16'h0002;
        strobe_i = 1;
        @(posedge clk_i); #1;
        ena_i = 0;
        @(posedge clk_i); #1;
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
        input expected_pn_o;
        begin
            if (expected_pn_o === (expected_pn_o ^ pn_o ^ expected_pn_o)) begin
                $display("PASS");
                $display("  Outputs: pn_o=%b",
                         pn_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pn_o=%b",
                         expected_pn_o);
                $display("  Got:      pn_o=%b",
                         pn_o);
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
        $dumpvars(0,clk_i, ena_i, mask_i, rst_i, strobe_i, pn_o);
    end

endmodule
