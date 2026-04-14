`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ex_LW;
    reg ex_WMEM;
    reg ex_WREG;
    reg [31:0] ex_aluresult;
    reg [31:0] ex_d2;
    reg [31:0] ex_instr;
    reg [31:0] ex_pc;
    reg [4:0] ex_td;
    reg rst;
    reg stall;
    wire me_LW;
    wire me_WMEM;
    wire me_WREG;
    wire [31:0] me_aluresult;
    wire [31:0] me_d2;
    wire [31:0] me_instr;
    wire [31:0] me_pc;
    wire [4:0] me_td;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ex_LW(ex_LW),
        .ex_WMEM(ex_WMEM),
        .ex_WREG(ex_WREG),
        .ex_aluresult(ex_aluresult),
        .ex_d2(ex_d2),
        .ex_instr(ex_instr),
        .ex_pc(ex_pc),
        .ex_td(ex_td),
        .rst(rst),
        .stall(stall),
        .me_LW(me_LW),
        .me_WMEM(me_WMEM),
        .me_WREG(me_WREG),
        .me_aluresult(me_aluresult),
        .me_d2(me_d2),
        .me_instr(me_instr),
        .me_pc(me_pc),
        .me_td(me_td)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        stall = 0;
        ex_LW = 0;
        ex_WMEM = 0;
        ex_WREG = 0;
        ex_aluresult = 32'h0;
        ex_d2 = 32'h0;
        ex_instr = 32'h0;
        ex_pc = 32'h0;
        ex_td = 5'h0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 0, 32'h0, 32'h0, 32'h0, 32'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Operation Pass-through", test_num);
        reset_dut();

        ex_LW = 1;
        ex_WMEM = 0;
        ex_WREG = 1;
        ex_aluresult = 32'hAAAA_BBBB;
        ex_d2 = 32'h1122_3344;
        ex_instr = 32'h00C5_0020;
        ex_pc = 32'h0000_1000;
        ex_td = 5'h1F;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0, 1, 32'hAAAA_BBBB, 32'h1122_3344, 32'h00C5_0020, 32'h0000_1000, 5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Stall Condition Logic", test_num);
        reset_dut();


        ex_LW = 1;
        ex_pc = 32'h0000_2000;
        stall = 0;
        @(posedge clk);
        #1;



        ex_LW = 1;
        ex_aluresult = 32'hFFFF_FFFF;
        ex_pc = 32'h0000_2004;
        stall = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(0, 0, 0, 32'h0, 32'h0, 32'h0, 32'h0000_2000, 5'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Recovery from Stall", test_num);
        reset_dut();


        ex_pc = 32'h3000;
        ex_aluresult = 32'h123;
        stall = 0;
        @(posedge clk);


        stall = 1;
        ex_pc = 32'h3004;
        ex_aluresult = 32'h456;
        @(posedge clk);


        stall = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 32'h456, 32'h0, 32'h0, 32'h3004, 5'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Multi-Cycle Pipeline Flow", test_num);
        reset_dut();


        ex_WREG = 1; ex_aluresult = 32'h1; ex_pc = 32'h10;
        @(posedge clk);


        ex_WREG = 0; ex_aluresult = 32'h2; ex_pc = 32'h14;
        @(posedge clk);
        #1;

        #1;


        check_outputs(0, 0, 0, 32'h2, 32'h0, 32'h0, 32'h14, 5'h0);
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
        input expected_me_LW;
        input expected_me_WMEM;
        input expected_me_WREG;
        input [31:0] expected_me_aluresult;
        input [31:0] expected_me_d2;
        input [31:0] expected_me_instr;
        input [31:0] expected_me_pc;
        input [4:0] expected_me_td;
        begin
            if (expected_me_LW === (expected_me_LW ^ me_LW ^ expected_me_LW) &&
                expected_me_WMEM === (expected_me_WMEM ^ me_WMEM ^ expected_me_WMEM) &&
                expected_me_WREG === (expected_me_WREG ^ me_WREG ^ expected_me_WREG) &&
                expected_me_aluresult === (expected_me_aluresult ^ me_aluresult ^ expected_me_aluresult) &&
                expected_me_d2 === (expected_me_d2 ^ me_d2 ^ expected_me_d2) &&
                expected_me_instr === (expected_me_instr ^ me_instr ^ expected_me_instr) &&
                expected_me_pc === (expected_me_pc ^ me_pc ^ expected_me_pc) &&
                expected_me_td === (expected_me_td ^ me_td ^ expected_me_td)) begin
                $display("PASS");
                $display("  Outputs: me_LW=%b, me_WMEM=%b, me_WREG=%b, me_aluresult=%h, me_d2=%h, me_instr=%h, me_pc=%h, me_td=%h",
                         me_LW, me_WMEM, me_WREG, me_aluresult, me_d2, me_instr, me_pc, me_td);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: me_LW=%b, me_WMEM=%b, me_WREG=%b, me_aluresult=%h, me_d2=%h, me_instr=%h, me_pc=%h, me_td=%h",
                         expected_me_LW, expected_me_WMEM, expected_me_WREG, expected_me_aluresult, expected_me_d2, expected_me_instr, expected_me_pc, expected_me_td);
                $display("  Got:      me_LW=%b, me_WMEM=%b, me_WREG=%b, me_aluresult=%h, me_d2=%h, me_instr=%h, me_pc=%h, me_td=%h",
                         me_LW, me_WMEM, me_WREG, me_aluresult, me_d2, me_instr, me_pc, me_td);
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
        $dumpvars(0,clk, ex_LW, ex_WMEM, ex_WREG, ex_aluresult, ex_d2, ex_instr, ex_pc, ex_td, rst, stall, me_LW, me_WMEM, me_WREG, me_aluresult, me_d2, me_instr, me_pc, me_td);
    end

endmodule
