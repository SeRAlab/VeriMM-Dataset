`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg s_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .s_in(s_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset_n = 0;
            s_in = 0;
            @(negedge clk);
            reset_n = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Asynchronous Reset", test_num);

            reset_n = 0;
            #2;
            #1;

            check_outputs(8'h00);
            reset_n = 1;
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %0d: Shifting in 0xFF", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                s_in = 1;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 3;
            pattern = 8'hAA;
            $display("Testcase %0d: Shifting in pattern 0xAA", test_num);
            reset_dut();

            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                s_in = pattern[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(pattern);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 4;
            pattern = 8'h55;
            $display("Testcase %0d: Shifting in pattern 0x55", test_num);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                s_in = pattern[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(pattern);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 5;
            pattern = 8'h3C;
            $display("Testcase %0d: Shifting in pattern 0x3C", test_num);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                s_in = pattern[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(pattern);
        end
        endtask

    task testcase006;

        integer i;
        reg [11:0] pattern;
        begin
            test_num = 6;
            pattern = 12'hACE;
            $display("Testcase %0d: Shifting 12 bits, checking overflow (expecting 0xCE)", test_num);
            reset_dut();
            for (i = 11; i >= 0; i = i - 1) begin
                @(negedge clk);
                s_in = pattern[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hCE);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset_n, s_in, q);
    end

endmodule
