`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] i_adr1;
    reg [4:0] i_adr2;
    reg [4:0] i_adr3;
    reg [31:0] i_wdata;
    reg i_wen;
    reg [4:0] i_wreg;
    reg rst;
    wire [31:0] o_op1;
    wire [31:0] o_op2;
    wire [31:0] o_op3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_adr1(i_adr1),
        .i_adr2(i_adr2),
        .i_adr3(i_adr3),
        .i_wdata(i_wdata),
        .i_wen(i_wen),
        .i_wreg(i_wreg),
        .rst(rst),
        .o_op1(o_op1),
        .o_op2(o_op2),
        .o_op3(o_op3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        i_adr1 = 0;
        i_adr2 = 0;
        i_adr3 = 0;
        i_wdata = 0;
        i_wen = 0;
        i_wreg = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Checking if all registers are zero after reset", test_num);
        i_adr1 = 5;
        i_adr2 = 12;
        i_adr3 = 31;
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Basic write and read from register 10", test_num);
        @(negedge clk);
        i_wreg = 5'd10;
        i_wdata = 32'hDEADBEEF;
        i_wen = 1;
        @(negedge clk);
        i_wen = 0;
        i_adr1 = 5'd10;
        i_adr2 = 5'd10;
        i_adr3 = 5'd10;
        #2;
        #1;

        check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Verifying Register 0 remains 0 after write attempt", test_num);
        @(negedge clk);
        i_wreg = 5'd0;
        i_wdata = 32'hFFFFFFFF;
        i_wen = 1;
        @(negedge clk);
        i_wen = 0;
        i_adr1 = 5'd0;
        i_adr2 = 5'd0;
        i_adr3 = 5'd0;
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Verifying i_wen=0 prevents writing", test_num);
        @(negedge clk);
        i_wreg = 5'd15;
        i_wdata = 32'h12345678;
        i_wen = 0;
        @(negedge clk);
        i_adr1 = 5'd15;
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Reading three different registers simultaneously", test_num);


        @(negedge clk);
        i_wreg = 5'd1; i_wdata = 32'hAAAA_AAAA; i_wen = 1;
        @(negedge clk);

        i_wreg = 5'd2; i_wdata = 32'hBBBB_BBBB; i_wen = 1;
        @(negedge clk);

        i_wreg = 5'd3; i_wdata = 32'hCCCC_CCCC; i_wen = 1;
        @(negedge clk);
        i_wen = 0;

        i_adr1 = 5'd1;
        i_adr2 = 5'd2;
        i_adr3 = 5'd3;
        #2;
        #1;

        check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %03d: Verifying boundary register (Reg 31)", test_num);
        @(negedge clk);
        i_wreg = 5'd31;
        i_wdata = 32'h55AA_55AA;
        i_wen = 1;
        @(negedge clk);
        i_wen = 0;
        i_adr1 = 5'd31;
        i_adr2 = 5'd0;
        i_adr3 = 5'd31;
        #2;
        #1;

        check_outputs(32'h55AA_55AA, 32'h0, 32'h55AA_55AA);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %03d: Verifying data overwrite in a register", test_num);
        @(negedge clk);
        i_wreg = 5'd20; i_wdata = 32'h1111_1111; i_wen = 1;
        @(negedge clk);
        i_wreg = 5'd20; i_wdata = 32'h2222_2222; i_wen = 1;
        @(negedge clk);
        i_wen = 0;
        i_adr1 = 5'd20;
        i_adr2 = 5'd20;
        i_adr3 = 5'd20;
        #2;
        #1;

        check_outputs(32'h2222_2222, 32'h2222_2222, 32'h2222_2222);
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
        input [31:0] expected_o_op1;
        input [31:0] expected_o_op2;
        input [31:0] expected_o_op3;
        begin
            if (expected_o_op1 === (expected_o_op1 ^ o_op1 ^ expected_o_op1) &&
                expected_o_op2 === (expected_o_op2 ^ o_op2 ^ expected_o_op2) &&
                expected_o_op3 === (expected_o_op3 ^ o_op3 ^ expected_o_op3)) begin
                $display("PASS");
                $display("  Outputs: o_op1=%h, o_op2=%h, o_op3=%h",
                         o_op1, o_op2, o_op3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_op1=%h, o_op2=%h, o_op3=%h",
                         expected_o_op1, expected_o_op2, expected_o_op3);
                $display("  Got:      o_op1=%h, o_op2=%h, o_op3=%h",
                         o_op1, o_op2, o_op3);
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
        $dumpvars(0,clk, i_adr1, i_adr2, i_adr3, i_wdata, i_wen, i_wreg, rst, o_op1, o_op2, o_op3);
    end

endmodule
