`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_alu;
    reg i_m2reg;
    reg [31:0] i_mo;
    reg [4:0] i_rn;
    reg i_wreg;
    reg rst;
    wire [31:0] o_alu;
    wire o_m2reg;
    wire [31:0] o_mo;
    wire [4:0] o_rn;
    wire o_wreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_alu(i_alu),
        .i_m2reg(i_m2reg),
        .i_mo(i_mo),
        .i_rn(i_rn),
        .i_wreg(i_wreg),
        .rst(rst),
        .o_alu(o_alu),
        .o_m2reg(o_m2reg),
        .o_mo(o_mo),
        .o_rn(o_rn),
        .o_wreg(o_wreg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_alu = 0;
            i_m2reg = 0;
            i_mo = 0;
            i_rn = 0;
            i_wreg = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 32'h0, 5'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning testcase %03d: Load standard data", test_num);
            reset_dut();

            i_alu   = 32'hDEADBEEF;
            i_m2reg = 1'b1;
            i_mo    = 32'hCAFEBABE;
            i_rn    = 5'd31;
            i_wreg  = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1, 32'hCAFEBABE, 5'd31, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning testcase %03d: Load alternate data", test_num);
            reset_dut();

            i_alu   = 32'h12345678;
            i_m2reg = 1'b0;
            i_mo    = 32'h87654321;
            i_rn    = 5'd15;
            i_wreg  = 1'b0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b0, 32'h87654321, 5'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning testcase %03d: All bits set to 1", test_num);
            reset_dut();

            i_alu   = 32'hFFFFFFFF;
            i_m2reg = 1'b1;
            i_mo    = 32'hFFFFFFFF;
            i_rn    = 5'b11111;
            i_wreg  = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 5'b11111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning testcase %03d: Reset priority check", test_num);
            reset_dut();


            i_alu   = 32'hAAAA_AAAA;
            i_m2reg = 1'b1;
            i_mo    = 32'h5555_5555;
            i_rn    = 5'h1F;
            i_wreg  = 1'b1;
            rst     = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0, 32'h0, 5'h0, 1'b0);


            rst = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning testcase %03d: Multi-cycle transition", test_num);
            reset_dut();


            i_alu   = 32'hA5A5_A5A5;
            i_m2reg = 1'b1;
            i_mo    = 32'h5A5A_5A5A;
            i_rn    = 5'h0A;
            i_wreg  = 1'b1;
            @(posedge clk);
            #1;


            i_alu   = 32'hB6B6_B6B6;
            i_m2reg = 1'b0;
            i_mo    = 32'h6B6B_6B6B;
            i_rn    = 5'h0B;
            i_wreg  = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hB6B6_B6B6, 1'b0, 32'h6B6B_6B6B, 5'h0B, 1'b0);
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
        input [31:0] expected_o_alu;
        input expected_o_m2reg;
        input [31:0] expected_o_mo;
        input [4:0] expected_o_rn;
        input expected_o_wreg;
        begin
            if (expected_o_alu === (expected_o_alu ^ o_alu ^ expected_o_alu) &&
                expected_o_m2reg === (expected_o_m2reg ^ o_m2reg ^ expected_o_m2reg) &&
                expected_o_mo === (expected_o_mo ^ o_mo ^ expected_o_mo) &&
                expected_o_rn === (expected_o_rn ^ o_rn ^ expected_o_rn) &&
                expected_o_wreg === (expected_o_wreg ^ o_wreg ^ expected_o_wreg)) begin
                $display("PASS");
                $display("  Outputs: o_alu=%h, o_m2reg=%b, o_mo=%h, o_rn=%h, o_wreg=%b",
                         o_alu, o_m2reg, o_mo, o_rn, o_wreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_alu=%h, o_m2reg=%b, o_mo=%h, o_rn=%h, o_wreg=%b",
                         expected_o_alu, expected_o_m2reg, expected_o_mo, expected_o_rn, expected_o_wreg);
                $display("  Got:      o_alu=%h, o_m2reg=%b, o_mo=%h, o_rn=%h, o_wreg=%b",
                         o_alu, o_m2reg, o_mo, o_rn, o_wreg);
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
        $dumpvars(0,clk, i_alu, i_m2reg, i_mo, i_rn, i_wreg, rst, o_alu, o_m2reg, o_mo, o_rn, o_wreg);
    end

endmodule
