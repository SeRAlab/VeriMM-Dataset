`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg is_nop;
    reg rst;
    wire [100:0] clk_no;
    wire [100:0] ins_no;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .is_nop(is_nop),
        .rst(rst),
        .clk_no(clk_no),
        .ins_no(ins_no)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        is_nop = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 10 cycles, 10 instructions (No NOPs)", test_num);
        reset_dut();
        is_nop = 0;
        repeat(10) @(negedge clk);
        #1;

        check_outputs(101'd10, 101'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 10 cycles, 0 instructions (All NOPs)", test_num);
        reset_dut();
        is_nop = 1;
        repeat(10) @(negedge clk);
        #1;

        check_outputs(101'd10, 101'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed NOPs (5 NOPs followed by 5 Instructions)", test_num);
        reset_dut();
        is_nop = 1;
        repeat(5) @(negedge clk);
        is_nop = 0;
        repeat(5) @(negedge clk);
        #1;

        check_outputs(101'd10, 101'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Instructions and NOPs (5 cycles each)", test_num);
        reset_dut();
        repeat(5) begin
            is_nop = 0; @(negedge clk);
            is_nop = 1; @(negedge clk);
        end
        #1;

        check_outputs(101'd10, 101'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset verification", test_num);
        reset_dut();

        #1;


        check_outputs(101'd0, 101'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single instruction cycle", test_num);
        reset_dut();
        is_nop = 0;
        @(negedge clk);
        #1;

        check_outputs(101'd1, 101'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single NOP cycle", test_num);
        reset_dut();
        is_nop = 1;
        @(negedge clk);
        #1;

        check_outputs(101'd1, 101'd0);
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
        input [100:0] expected_clk_no;
        input [100:0] expected_ins_no;
        begin
            if (expected_clk_no === (expected_clk_no ^ clk_no ^ expected_clk_no) &&
                expected_ins_no === (expected_ins_no ^ ins_no ^ expected_ins_no)) begin
                $display("PASS");
                $display("  Outputs: clk_no=%h, ins_no=%h",
                         clk_no, ins_no);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_no=%h, ins_no=%h",
                         expected_clk_no, expected_ins_no);
                $display("  Got:      clk_no=%h, ins_no=%h",
                         clk_no, ins_no);
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
        $dumpvars(0,clk, is_nop, rst, clk_no, ins_no);
    end

endmodule
