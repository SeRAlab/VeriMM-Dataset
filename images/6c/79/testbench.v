`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCWrite;
    reg clk_i;
    reg [31:0] pc_in_i;
    reg rst_n;
    wire [31:0] pc_out_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCWrite(PCWrite),
        .clk_i(clk_i),
        .pc_in_i(pc_in_i),
        .rst_n(rst_n),
        .pc_out_o(pc_out_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        rst_n = 0;
        PCWrite = 0;
        pc_in_i = 32'h0;
        #12;
        rst_n = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset Functionality", test_num);
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Loading value with PCWrite=1", test_num);
        reset_dut();
        @(posedge clk_i);
        PCWrite = 1;
        pc_in_i = 32'hABCD1234;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(32'hABCD1234);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Holding value with PCWrite=0", test_num);
        reset_dut();

        @(posedge clk_i);
        PCWrite = 1;
        pc_in_i = 32'h5555AAAA;
        @(posedge clk_i);

        PCWrite = 0;
        pc_in_i = 32'hFFFFFFFF;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Successive Writes", test_num);
        reset_dut();
        @(posedge clk_i);
        PCWrite = 1;
        pc_in_i = 32'h00000010;
        @(posedge clk_i);
        pc_in_i = 32'h00000020;
        @(posedge clk_i);
        pc_in_i = 32'h00000030;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(32'h00000030);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Writing Zero value", test_num);
        reset_dut();
        @(posedge clk_i);
        PCWrite = 1;
        pc_in_i = 32'hFFFFFFFF;
        @(posedge clk_i);
        pc_in_i = 32'h00000000;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating Write and Hold", test_num);
        reset_dut();
        @(posedge clk_i);
        PCWrite = 1; pc_in_i = 32'h11111111;
        @(posedge clk_i);
        PCWrite = 0; pc_in_i = 32'h22222222;
        @(posedge clk_i);
        PCWrite = 1; pc_in_i = 32'h33333333;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(32'h33333333);
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
        input [31:0] expected_pc_out_o;
        begin
            if (expected_pc_out_o === (expected_pc_out_o ^ pc_out_o ^ expected_pc_out_o)) begin
                $display("PASS");
                $display("  Outputs: pc_out_o=%h",
                         pc_out_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out_o=%h",
                         expected_pc_out_o);
                $display("  Got:      pc_out_o=%h",
                         pc_out_o);
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
        $dumpvars(0,PCWrite, clk_i, pc_in_i, rst_n, pc_out_o);
    end

endmodule
