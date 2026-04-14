`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Write_EN;
    reg [31:0] Write_Val;
    reg clk;
    reg [4:0] dest;
    reg rst;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [31:0] reg1;
    wire [31:0] reg2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Write_EN(Write_EN),
        .Write_Val(Write_Val),
        .clk(clk),
        .dest(dest),
        .rst(rst),
        .src1(src1),
        .src2(src2),
        .reg1(reg1),
        .reg2(reg2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Write_EN = 0;
            Write_Val = 0;
            dest = 0;
            src1 = 0;
            src2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initialization Check", test_num);
            reset_dut();
            src1 = 5'd7;
            src2 = 5'd24;
            #5;
            #1;

            check_outputs(32'd7, 32'd24);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write/Read", test_num);
            reset_dut();
            @(posedge clk);
            dest = 5'd10;
            Write_Val = 32'hA5A5_5A5A;
            Write_EN = 1;

            @(negedge clk);
            #2;
            Write_EN = 0;
            src1 = 5'd10;
            src2 = 5'd0;
            #5;
            #1;

            check_outputs(32'hA5A5_5A5A, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Dual Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            dest = 5'd1;
            Write_Val = 32'h1111_1111;
            Write_EN = 1;
            @(negedge clk);


            @(posedge clk);
            dest = 5'd2;
            Write_Val = 32'h2222_2222;
            @(negedge clk);

            #2 Write_EN = 0;
            src1 = 5'd1;
            src2 = 5'd2;
            #5;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write Enable Validation", test_num);
            reset_dut();
            @(posedge clk);
            dest = 5'd15;
            Write_Val = 32'hFFFF_FFFF;
            Write_EN = 0;
            @(negedge clk);
            #2;
            src1 = 5'd15;
            src2 = 5'd0;
            #5;
            #1;

            check_outputs(32'd15, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overwrite Register", test_num);
            reset_dut();


            @(posedge clk);
            dest = 5'd31;
            Write_Val = 32'hCAFE_BABE;
            Write_EN = 1;
            @(negedge clk);


            @(posedge clk);
            Write_Val = 32'hDEAD_BEEF;
            @(negedge clk);

            #2 Write_EN = 0;
            src1 = 5'd31;
            src2 = 5'd31;
            #5;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'hDEAD_BEEF);
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
        input [31:0] expected_reg1;
        input [31:0] expected_reg2;
        begin
            if (expected_reg1 === (expected_reg1 ^ reg1 ^ expected_reg1) &&
                expected_reg2 === (expected_reg2 ^ reg2 ^ expected_reg2)) begin
                $display("PASS");
                $display("  Outputs: reg1=%h, reg2=%h",
                         reg1, reg2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg1=%h, reg2=%h",
                         expected_reg1, expected_reg2);
                $display("  Got:      reg1=%h, reg2=%h",
                         reg1, reg2);
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
        $dumpvars(0,Write_EN, Write_Val, clk, dest, rst, src1, src2, reg1, reg2);
    end

endmodule
