`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg X_in;
    reg clk;
    reg rst;
    reg sx;
    wire fx;
    wire [10:0] x_par;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X_in(X_in),
        .clk(clk),
        .rst(rst),
        .sx(sx),
        .fx(fx),
        .x_par(x_par)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            X_in = 0;
            sx = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            reset_dut();
            sx = 1;
            for (i = 0; i < 11; i = i + 1) begin
                X_in = 1;
                @(posedge clk);
                #1;
            end
            sx = 0;

            #1;


            check_outputs(1'b1, 11'h7FF);
        end
        endtask

    task testcase002;

        integer i;
        reg [10:0] pattern;
        begin
            reset_dut();
            pattern = 11'b10101010101;
            sx = 1;
            for (i = 10; i >= 0; i = i - 1) begin
                X_in = pattern[i];
                @(posedge clk);
                #1;
            end
            sx = 0;


            #1;



            check_outputs(1'b1, 11'b10101010101);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            sx = 1;

            for (i = 0; i < 5; i = i + 1) begin
                X_in = 1;
                @(posedge clk);
                #1;
            end

            sx = 0;
            X_in = 0;
            repeat(3) @(posedge clk);
            #1;

            sx = 1;
            for (i = 0; i < 6; i = i + 1) begin
                X_in = 0;
                @(posedge clk);
                #1;
            end
            sx = 0;

            #1;


            check_outputs(1'b1, 11'b11111000000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            sx = 1;

            for (i = 0; i < 5; i = i + 1) begin
                X_in = 1;
                @(posedge clk);
                #1;
            end

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;

            for (i = 0; i < 11; i = i + 1) begin
                X_in = 1;
                @(posedge clk);
                #1;
            end
            sx = 0;
            #1;

            check_outputs(1'b1, 11'h7FF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            sx = 1;

            for (i = 0; i < 10; i = i + 1) begin
                X_in = 1;
                @(posedge clk);
                #1;
            end
            sx = 0;

            #1;


            check_outputs(1'b0, x_par);
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
        input expected_fx;
        input [10:0] expected_x_par;
        begin
            if (expected_fx === (expected_fx ^ fx ^ expected_fx) &&
                expected_x_par === (expected_x_par ^ x_par ^ expected_x_par)) begin
                $display("PASS");
                $display("  Outputs: fx=%b, x_par=%h",
                         fx, x_par);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fx=%b, x_par=%h",
                         expected_fx, expected_x_par);
                $display("  Got:      fx=%b, x_par=%h",
                         fx, x_par);
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
        $dumpvars(0,X_in, clk, rst, sx, fx, x_par);
    end

endmodule
