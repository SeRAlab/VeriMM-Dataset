`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    reg we;
    wire [7:0] dout;
    wire re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .we(we),
        .dout(dout),
        .re(re)
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
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Single Write 0xA5");

            we = 1;
            din = 8'hA5;
            @(posedge clk);
            we = 0;


            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Multiple Writes 0x11, 0x22, 0x33");

            @(posedge clk);
            we = 1; din = 8'h11;
            @(posedge clk);
            we = 1; din = 8'h22;
            @(posedge clk);
            we = 1; din = 8'h33;
            @(posedge clk);
            we = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Fill FIFO to depth 16");

            we = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i + 8'h10;
                @(posedge clk);
            end
            we = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Overflow Attempt (17 writes)");

            we = 1;
            for (i = 0; i < 17; i = i + 1) begin
                din = i + 8'h60;
                @(posedge clk);
            end
            we = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(8'h60, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Post-Reset state check");


            we = 1; din = 8'hFF;
            @(posedge clk);
            we = 0;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1 #1;
 check_outputs(dout, 1'b0);
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
        input [7:0] expected_dout;
        input expected_re;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_re === (expected_re ^ re ^ expected_re)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, re=%b",
                         dout, re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, re=%b",
                         expected_dout, expected_re);
                $display("  Got:      dout=%h, re=%b",
                         dout, re);
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
        $dumpvars(0,clk, din, rst, we, dout, re);
    end

endmodule
