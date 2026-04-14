`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] dst;
    reg [7:0] ip;
    reg rst;
    reg [1:0] src1;
    reg [1:0] src2;
    reg we;
    wire [7:0] op1;
    wire [7:0] op2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dst(dst),
        .ip(ip),
        .rst(rst),
        .src1(src1),
        .src2(src2),
        .we(we),
        .op1(op1),
        .op2(op2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            dst = 2'b00;
            ip = 8'h00;
            src1 = 2'b00;
            src2 = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();
            src1 = 2'd0;
            src2 = 2'd3;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write to Reg 0 and Read Back", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            dst = 2'd0;
            ip = 8'hA5;
            @(posedge clk);
            @(negedge clk);
            we = 0;
            src1 = 2'd0;
            src2 = 2'd0;
            #2;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Read of Two Registers", test_num);
            reset_dut();

            @(negedge clk);
            we = 1; dst = 2'd1; ip = 8'h11;
            @(posedge clk);

            @(negedge clk);
            we = 1; dst = 2'd2; ip = 8'h22;
            @(posedge clk);
            @(negedge clk);
            we = 0;
            src1 = 2'd1;
            src2 = 2'd2;
            #2;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();

            @(negedge clk);
            we = 1; dst = 2'd3; ip = 8'hCC;
            @(posedge clk);

            @(negedge clk);
            we = 0; dst = 2'd3; ip = 8'hFF;
            @(posedge clk);
            @(negedge clk);
            src1 = 2'd3;
            src2 = 2'd3;
            #2;
            #1;

            check_outputs(8'hCC, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Register Overwrite", test_num);
            reset_dut();

            @(negedge clk);
            we = 1; dst = 2'd1; ip = 8'h10;
            @(posedge clk);

            @(negedge clk);
            we = 1; dst = 2'd1; ip = 8'h20;
            @(posedge clk);
            @(negedge clk);
            we = 0; src1 = 2'd1; src2 = 2'd1;
            #2;
            #1;

            check_outputs(8'h20, 8'h20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Full Register File Test", test_num);
            reset_dut();

            @(negedge clk); we = 1; dst = 2'd0; ip = 8'h01; @(posedge clk);
            @(negedge clk); we = 1; dst = 2'd1; ip = 8'h02; @(posedge clk);
            @(negedge clk); we = 1; dst = 2'd2; ip = 8'h03; @(posedge clk);
            @(negedge clk); we = 1; dst = 2'd3; ip = 8'h04; @(posedge clk);
            @(negedge clk);
            we = 0;
            src1 = 2'd3;
            src2 = 2'd0;
            #2;
            #1;

            check_outputs(8'h04, 8'h01);
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
        input [7:0] expected_op1;
        input [7:0] expected_op2;
        begin
            if (expected_op1 === (expected_op1 ^ op1 ^ expected_op1) &&
                expected_op2 === (expected_op2 ^ op2 ^ expected_op2)) begin
                $display("PASS");
                $display("  Outputs: op1=%h, op2=%h",
                         op1, op2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op1=%h, op2=%h",
                         expected_op1, expected_op2);
                $display("  Got:      op1=%h, op2=%h",
                         op1, op2);
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
        $dumpvars(0,clk, dst, ip, rst, src1, src2, we, op1, op2);
    end

endmodule
