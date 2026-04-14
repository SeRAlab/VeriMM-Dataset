`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [31:0] instr;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .instr(instr),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 32'b0;
            b = 32'b0;
            instr = 32'b0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd150;
            b = 32'd350;
            instr = 32'h01;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Addition (150 + 350)", test_num);
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd1000;
            b = 32'd400;
            instr = 32'h02;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Subtraction (1000 - 400)", test_num);
            #1;

            check_outputs(32'd600);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd12;
            b = 32'd11;
            instr = 32'h03;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Multiplication (12 * 11)", test_num);
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd500;
            b = 32'd20;
            instr = 32'h04;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Division (500 / 20)", test_num);
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'hF0F0F0F0;
            b = 32'hAAAA5555;
            instr = 32'h05;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Logical AND", test_num);
            #1;

            check_outputs(32'hA0A05050);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'hF0F00000;
            b = 32'h0000AAAA;
            instr = 32'h06;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Logical OR", test_num);
            #1;

            check_outputs(32'hF0F0AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'hFFFF0000;
            instr = 32'h07;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Logical NOT", test_num);
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h00000001;
            b = 32'd10;
            instr = 32'h08;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Shift Left Logical (1 << 10)", test_num);
            #1;

            check_outputs(32'h00000400);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h00000400;
            b = 32'd4;
            instr = 32'h09;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Shift Right Logical (0x400 >> 4)", test_num);
            #1;

            check_outputs(32'h00000040);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd5;
            b = 32'd10;
            instr = 32'h02;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #2;
            $display("Testcase %03d: Subtraction (5 - 10 = -5)", test_num);
            #1;

            check_outputs(32'hFFFFFBF);
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,a, b, clk, instr, out);
    end

endmodule
