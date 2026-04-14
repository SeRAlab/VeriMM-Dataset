`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg load_enable;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .load_enable(load_enable),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 32'h0;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;
            in = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in = 32'hA5A5_5A5A;
            load_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            in = 32'h1234_5678;
            load_enable = 1;
            @(posedge clk);
            #1;

            load_enable = 0;
            in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 32'hFFFF_FFFF;
            load_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            in = 32'hAAAA_AAAA;
            load_enable = 1;
            @(posedge clk);
            #1;

            in = 32'h5555_5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 32'hDEAD_BEEF;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;
            in = 32'h0000_0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, load_enable, out);
    end

endmodule
