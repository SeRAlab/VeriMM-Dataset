`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] a;
    reg [13:0] b;
    reg [31:0] c;
    reg clk;
    reg en;
    reg rst_n;
    wire [31:0] d;
    wire [13:0] e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .d(d),
        .e(e)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            a = 0;
            b = 0;
            c = 0;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 14'sd10;
            b = 14'sd5;
            c = 32'sd100;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd150, 14'sd10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = -14'sd10;
            b = 14'sd5;
            c = 32'sd100;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd50, -14'sd10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = -14'sd20;
            b = -14'sd30;
            c = -32'sd1000;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-32'sd400, -14'sd20);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            a = 14'sd10;
            b = 14'sd10;
            c = 32'sd0;
            en = 1;
            @(posedge clk);
            #2;

            en = 0;
            a = 14'sd50;
            b = 14'sd50;
            c = 32'sd500;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'sd100, 14'sd50);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 14'sd8191;
            b = 14'sd8191;
            c = 32'sd1000000;
            en = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'sd68092481, 14'sd8191);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = -14'sd8192;
            b = 14'sd8191;
            c = -32'sd1;
            en = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(-32'sd67100673, -14'sd8192);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 0;
            b = 14'sd500;
            c = 32'sd12345;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd12345, 0);
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
        input [31:0] expected_d;
        input [13:0] expected_e;
        begin
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e)) begin
                $display("PASS");
                $display("  Outputs: d=%h, e=%h",
                         d, e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h, e=%h",
                         expected_d, expected_e);
                $display("  Got:      d=%h, e=%h",
                         d, e);
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
        $dumpvars(0,a, b, c, clk, en, rst_n, d, e);
    end

endmodule
