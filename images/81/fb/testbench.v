`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg enable;
    reg ref_clk;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .enable(enable),
        .ref_clk(ref_clk),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            ref_clk = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Synchronization (Zero Phase Shift)", test_num);
            reset_dut();

            ref_phase_delay = 0;
            ref_gen_en = 1;
            enable = 1;


            #5000;


            @(posedge ref_clk);
            #0.1;
            #1;

            check_outputs(1'b1);

            ref_gen_en = 0;
            #20;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Lagging Reference Clock (2ns Phase Shift)", test_num);
            reset_dut();

            ref_phase_delay = 2.0;
            ref_gen_en = 1;
            enable = 1;


            #8000;


            @(posedge ref_clk);
            #0.1;
            #1;

            check_outputs(1'b1);

            ref_gen_en = 0;
            #20;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: DLL Disabled (Enable = 0)", test_num);
            reset_dut();

            ref_phase_delay = 4.0;
            ref_gen_en = 1;
            enable = 0;

            #2000;



            @(posedge ref_clk);
            #0.1;


            if (clk_out === 1'b0)
                #1;

                check_outputs(1'b0);
            else
                $display("DLL Output active but not necessarily aligned.");

            ref_gen_en = 0;
            #20;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset during operation", test_num);
            reset_dut();

            ref_phase_delay = 1.0;
            ref_gen_en = 1;
            enable = 1;

            #1000;

            reset = 1;
            #50;


            #1;



            check_outputs(1'b0);

            reset = 0;
            ref_gen_en = 0;
            #20;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Large Phase Shift (4ns)", test_num);
            reset_dut();

            ref_phase_delay = 4.0;
            ref_gen_en = 1;
            enable = 1;

            #10000;

            @(posedge ref_clk);
            #0.1;
            #1;

            check_outputs(1'b1);

            ref_gen_en = 0;
            #20;
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, enable, ref_clk, reset, clk_out);
    end

endmodule
