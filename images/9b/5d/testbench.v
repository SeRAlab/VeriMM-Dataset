`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] a;
    reg clk;
    reg [15:0] d;
    reg we;
    wire [15:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .we(we),
        .spo(spo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            d = 0;
            we = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Push and Pop", test_num);
            reset_dut();

            @(posedge clk); #1; we = 1; d = 16'hAAAA;

            @(posedge clk); #1; we = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LIFO Verification", test_num);
            reset_dut();

            @(posedge clk); #1; we = 1; d = 16'h1111;
            @(posedge clk); #1; we = 1; d = 16'h2222;
            @(posedge clk); #1; we = 1; d = 16'h3333;

            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Push/Pop", test_num);
            reset_dut();

            @(posedge clk); #1; we = 1; d = 16'h0001;
            @(posedge clk); #1; we = 1; d = 16'h0002;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 1; d = 16'h0003;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Deep Stack Persistence", test_num);
            reset_dut();

            @(posedge clk); #1; we = 1; d = 16'h0010;
            @(posedge clk); #1; we = 1; d = 16'h0020;
            @(posedge clk); #1; we = 1; d = 16'h0030;
            @(posedge clk); #1; we = 1; d = 16'h0040;
            @(posedge clk); #1; we = 1; d = 16'h0050;

            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h0020);


            @(posedge clk); #1; we = 0;
            @(posedge clk); #1;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Integrity (Large Values)", test_num);
            reset_dut();
            @(posedge clk); #1; we = 1; d = 16'hFFFF;
            @(posedge clk); #1; we = 1; d = 16'h55AA;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1; we = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_spo;
        begin
            if (expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: spo=%h",
                         spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spo=%h",
                         expected_spo);
                $display("  Got:      spo=%h",
                         spo);
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
        $dumpvars(0,a, clk, d, we, spo);
    end

endmodule
