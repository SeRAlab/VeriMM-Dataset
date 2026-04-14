`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CCLK;
    reg [31:0] instr;
    reg rst;
    wire [7:0] IF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CCLK(CCLK),
        .instr(instr),
        .rst(rst),
        .IF(IF)
    );

    // Clock generation (10ns period)
    initial begin
        CCLK = 0;
        forever #5 CCLK = ~CCLK;
    end

        task reset_dut;

    begin
        rst = 1;
        instr = 32'h0;
        @(posedge CCLK);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: R-type ADD", test_num);
        reset_dut();
        instr = {6'h00, 20'h0, 6'h20};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: R-type SUB", test_num);
        reset_dut();
        instr = {6'h00, 20'h0, 6'h22};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: LW Instruction", test_num);
        reset_dut();
        instr = {6'h23, 26'h0};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: SW Instruction", test_num);
        reset_dut();
        instr = {6'h2B, 26'h0};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: BEQ Instruction", test_num);
        reset_dut();
        instr = {6'h04, 26'h0};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: JUMP Instruction", test_num);
        reset_dut();
        instr = {6'h02, 26'h0};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: ADDI Instruction", test_num);
        reset_dut();
        instr = {6'h08, 26'h0};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: R-type AND", test_num);
        reset_dut();
        instr = {6'h00, 20'h0, 6'h24};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: R-type OR", test_num);
        reset_dut();
        instr = {6'h00, 20'h0, 6'h25};
        @(posedge CCLK);
        #2;
        #1;

        check_outputs(8'd4);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_IF;
        begin
            if (expected_IF === (expected_IF ^ IF ^ expected_IF)) begin
                $display("PASS");
                $display("  Outputs: IF=%h",
                         IF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF=%h",
                         expected_IF);
                $display("  Got:      IF=%h",
                         IF);
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
        $dumpvars(0,CCLK, instr, rst, IF);
    end

endmodule
