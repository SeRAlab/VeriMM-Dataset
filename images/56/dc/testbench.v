`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d_clr;
    reg d_dec;
    reg d_inc;
    reg reset;
    wire [3:0] dig0;
    wire [3:0] dig1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_clr(d_clr),
        .d_dec(d_dec),
        .d_inc(d_inc),
        .reset(reset),
        .dig0(dig0),
        .dig1(dig1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d_inc = 0;
            d_dec = 0;
            d_clr = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            d_inc = 1;
            @(posedge clk);
            d_inc = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                d_inc = 1;
                @(posedge clk);
                d_inc = 0;
            end
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd5);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                d_inc = 1;
                @(posedge clk);
                d_inc = 0;
            end
            @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            repeat(2) begin
                @(posedge clk); d_inc = 1; @(posedge clk); d_inc = 0;
            end

            @(posedge clk); d_dec = 1; @(posedge clk); d_dec = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            repeat(5) begin
                @(posedge clk); d_inc = 1; @(posedge clk); d_inc = 0;
            end

            @(posedge clk);
            d_clr = 1;
            @(posedge clk);
            d_clr = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(posedge clk);
            d_dec = 1;
            @(posedge clk);
            d_dec = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 25; i = i + 1) begin
                @(posedge clk);
                d_inc = 1;
                @(posedge clk);
                d_inc = 0;
            end
            @(posedge clk);
            #1;

            check_outputs(4'd2, 4'd5);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            @(posedge clk);
            d_inc = 1;
            d_clr = 1;
            @(posedge clk);
            d_inc = 0;
            d_clr = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            repeat(3) begin
                @(posedge clk); d_inc = 1; @(posedge clk); d_inc = 0;
            end
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd0);
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
        input [3:0] expected_dig0;
        input [3:0] expected_dig1;
        begin
            if (expected_dig0 === (expected_dig0 ^ dig0 ^ expected_dig0) &&
                expected_dig1 === (expected_dig1 ^ dig1 ^ expected_dig1)) begin
                $display("PASS");
                $display("  Outputs: dig0=%h, dig1=%h",
                         dig0, dig1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dig0=%h, dig1=%h",
                         expected_dig0, expected_dig1);
                $display("  Got:      dig0=%h, dig1=%h",
                         dig0, dig1);
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
        $dumpvars(0,clk, d_clr, d_dec, d_inc, reset, dig0, dig1);
    end

endmodule
