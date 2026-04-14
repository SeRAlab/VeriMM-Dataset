`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] d;
    reg load;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .d(d),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            load = 0;
            d = 0;
            #10;
            reset = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Data 16'hA5A5", test_num);
            reset_dut();
            d = 16'hA5A5;
            load = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load Data 16'h5A5A", test_num);
            reset_dut();
            d = 16'h5A5A;
            load = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load then Disable Load (Hold)", test_num);
            reset_dut();

            d = 16'hBEEF;
            load = 1;
            @(posedge clock);
            #2;

            d = 16'hDEAD;
            load = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Priority over Load", test_num);
            reset_dut();

            d = 16'hFFFF;
            load = 1;
            reset = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Loads", test_num);
            reset_dut();

            d = 16'h1111; load = 1;
            @(posedge clock);
            #2;

            d = 16'h2222; load = 1;
            @(posedge clock);
            #2;

            d = 16'h3333; load = 1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(16'h3333);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Asynchronous Reset Mid-cycle", test_num);
            reset_dut();


            d = 16'hCCCC;
            load = 1;
            @(posedge clock);
            #2;


            #3;
            reset = 1;
            #1;
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
        input [15:0] expected_q;
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
        $dumpvars(0,clock, d, load, reset, q);
    end

endmodule
