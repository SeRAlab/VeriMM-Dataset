`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    reg we;
    wire [31:0] dout;
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
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            we = 1;
            din = 1;
            @(posedge clk);
            we = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h00000001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            we = 1;
            din = 0;
            @(posedge clk);
            we = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                we = 1;
                din = 1;
                @(posedge clk);
            end
            we = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'h00000001, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            we = 1; din = 0; @(posedge clk);
            for (i = 0; i < 9; i = i + 1) begin
                we = 1; din = 1; @(posedge clk);
            end
            we = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            we = 1; din = 1;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            reset_dut();
            #1;

            check_outputs(32'h00000000, 1'b0);
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
        input [31:0] expected_dout;
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
