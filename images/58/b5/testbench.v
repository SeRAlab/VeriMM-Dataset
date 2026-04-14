`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [31:0] i_pc;
    reg i_rst_n;
    wire [31:0] o_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_pc(i_pc),
        .i_rst_n(i_rst_n),
        .o_pc(o_pc)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_rst_n = 0;
        i_pc = 32'h0;
        #12;
        i_rst_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Standard Address (0x12345678)", test_num);
        reset_dut();
        i_pc = 32'h12345678;
        @(posedge i_clk);
        #2;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Maximum Address (0xFFFFFFFF)", test_num);
        reset_dut();
        i_pc = 32'hFFFFFFFF;
        @(posedge i_clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Load Check", test_num);
        reset_dut();
        i_pc = 32'h00000004;
        @(posedge i_clk);
        #2;
        i_pc = 32'h00000008;
        @(posedge i_clk);
        #2;
        i_pc = 32'h0000000C;
        @(posedge i_clk);
        #2;
        #1;

        check_outputs(32'h0000000C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits (0x5555AAAA)", test_num);
        reset_dut();
        i_pc = 32'h5555AAAA;
        @(posedge i_clk);
        #2;
        #1;

        check_outputs(32'h5555AAAA);
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
        input [31:0] expected_o_pc;
        begin
            if (expected_o_pc === (expected_o_pc ^ o_pc ^ expected_o_pc)) begin
                $display("PASS");
                $display("  Outputs: o_pc=%h",
                         o_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_pc=%h",
                         expected_o_pc);
                $display("  Got:      o_pc=%h",
                         o_pc);
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
        $dumpvars(0,i_clk, i_pc, i_rst_n, o_pc);
    end

endmodule
