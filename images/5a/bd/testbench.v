`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] d;
    reg ld;
    reg rst;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .ld(ld),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ld = 0;
            d = 0;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Load Operation", test_num);
            reset_dut();
            d = 64'hFEDCBA9876543210;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load and Hold", test_num);
            reset_dut();

            d = 64'hAAAA_BBBB_CCCC_DDDD;
            ld = 1;
            @(posedge clk);
            #2;

            ld = 0;
            d = 64'h1111_2222_3333_4444;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Asynchronous Reset Check", test_num);
            reset_dut();

            d = 64'hFFFF_FFFF_FFFF_FFFF;
            ld = 1;
            @(posedge clk);
            #2;

            rst = 1;
            #1;
            #1;

            check_outputs(64'h0);
            #2;
            rst = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load All Ones", test_num);
            reset_dut();
            d = 64'hFFFF_FFFF_FFFF_FFFF;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Priority Over Load", test_num);
            reset_dut();
            d = 64'h5555_AAAA_5555_AAAA;
            ld = 1;
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();
            d = 64'h5A5A_A5A5_5A5A_A5A5;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h5A5A_A5A5_5A5A_A5A5);
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
        input [63:0] expected_q;
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
        $dumpvars(0,clk, d, ld, rst, q);
    end

endmodule
