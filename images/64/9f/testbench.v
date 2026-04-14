`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] lr_in;
    reg rst;
    reg wr_en;
    wire [15:0] lr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .lr_in(lr_in),
        .rst(rst),
        .wr_en(wr_en),
        .lr_out(lr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            wr_en = 0;
            lr_in = 16'h0000;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write (0xABCD)", test_num);
            reset_dut();
            @(negedge clk);
            wr_en = 1;
            lr_in = 16'hABCD;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write Disabled (Data shouldn't change)", test_num);
            reset_dut();

            @(negedge clk);
            wr_en = 1;
            lr_in = 16'h1234;
            @(posedge clk);

            @(negedge clk);
            wr_en = 0;
            lr_in = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Successive Writes", test_num);
            reset_dut();

            @(negedge clk);
            wr_en = 1;
            lr_in = 16'hAAAA;
            @(posedge clk);

            @(negedge clk);
            lr_in = 16'h5555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset override", test_num);
            reset_dut();
            @(negedge clk);
            wr_en = 1;
            lr_in = 16'h8888;
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_lr_out;
        begin
            if (expected_lr_out === (expected_lr_out ^ lr_out ^ expected_lr_out)) begin
                $display("PASS");
                $display("  Outputs: lr_out=%h",
                         lr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lr_out=%h",
                         expected_lr_out);
                $display("  Got:      lr_out=%h",
                         lr_out);
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
        $dumpvars(0,clk, lr_in, rst, wr_en, lr_out);
    end

endmodule
