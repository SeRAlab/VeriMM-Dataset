`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [31:0] d;
    reg load;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .d(d),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

    begin
        clear = 1;
        load = 0;
        d = 0;
        #10;
        clear = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        d = 32'hDEADBEEF;
        load = 1;
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
        load = 0;
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        d = 32'h12345678;
        load = 1;
        #5;
        load = 0;

        clear = 1;
        #2;
        #1;

        check_outputs(32'h00000000);
        clear = 0;
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        d = 32'hFFFFFFFF;
        load = 1;
        clear = 1;
        #5;

        #1;


        check_outputs(32'h00000000);
        load = 0;
        clear = 0;
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        d = 32'hA5A5A5A5;
        load = 1;
        #5;
        load = 0;
        d = 32'h00000000;
        #15;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        d = 32'hFFFFFFFF;
        load = 1;
        #5;

        d = 32'h00000000;
        #5;
        #1;

        check_outputs(32'h00000000);
        load = 0;
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        d = 32'h55AA55AA;
        #3;
        load = 1;
        #1;
        load = 0;
        #1;
        #1;

        check_outputs(32'h55AA55AA);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clear, clk, d, load, q);
    end

endmodule
