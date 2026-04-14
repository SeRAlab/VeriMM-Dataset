`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] in;
    reg load;
    reg reset;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in(in),
        .load(load),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 32'h0;
            load = 0;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load value 0xDEADBEEF", test_num);
            reset_dut();
            @(negedge clock);
            in = 32'hDEADBEEF;
            load = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Data Retention (Hold)", test_num);
            reset_dut();

            @(negedge clock);
            in = 32'hA5A5A5A5;
            load = 1;
            @(posedge clock);

            @(negedge clock);
            load = 0;
            in = 32'hFFFFFFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Asynchronous Reset Priority", test_num);
            reset_dut();

            @(negedge clock);
            in = 32'h12345678;
            load = 1;
            @(posedge clock);
            #2;

            #1 reset = 1;
            #1 #1;
 check_outputs(32'h00000000);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Load All Ones", test_num);
            reset_dut();
            @(negedge clock);
            in = 32'hFFFFFFFF;
            load = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequential Load Updates", test_num);
            reset_dut();
            @(negedge clock);
            in = 32'h11111111;
            load = 1;
            @(posedge clock);
            @(negedge clock);
            in = 32'h22222222;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h22222222);
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
        $dumpvars(0,clock, in, load, reset, out);
    end

endmodule
