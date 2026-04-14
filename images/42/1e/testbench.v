`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ch_c;
    reg sys_clk_50m;
    reg sys_rst_n;
    wire [63:0] freq_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ch_c(ch_c),
        .sys_clk_50m(sys_clk_50m),
        .sys_rst_n(sys_rst_n),
        .freq_reg(freq_reg)
    );

    // Clock generation (10ns period)
    initial begin
        ch_c = 0;
        forever #5 ch_c = ~ch_c;
    end

        task reset_dut;

        begin
            sys_rst_n = 0;
            #(20 * 10);
            sys_rst_n = 1;
            #(20 * 10);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\n--- Testcase %0d: Measuring 100MHz signal ---", test_num);
            ch_c_half_period = 5.0;
            ch_c_en = 1;
            reset_dut();



            #2000000000;

            #1;


            check_outputs(64'd100_000_000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\n--- Testcase %0d: Measuring 50MHz signal ---", test_num);
            ch_c_half_period = 10.0;
            ch_c_en = 1;
            reset_dut();

            #2000000000;

            #1;


            check_outputs(64'd50_000_000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\n--- Testcase %0d: Measuring 12.5MHz signal ---", test_num);
            ch_c_half_period = 40.0;
            ch_c_en = 1;
            reset_dut();

            #2000000000;

            #1;


            check_outputs(64'd12_500_000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\n--- Testcase %0d: Input Signal Stopped (0Hz) ---", test_num);
            ch_c_en = 0;
            reset_dut();

            #2000000000;

            #1;


            check_outputs(64'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\n--- Testcase %0d: Reset Behavior Check ---", test_num);
            ch_c_half_period = 5.0;
            ch_c_en = 1;


            #1100000000;


            sys_rst_n = 0;
            #200;
            sys_rst_n = 1;


            #1;



            check_outputs(64'd0);
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
        input [63:0] expected_freq_reg;
        begin
            if (expected_freq_reg === (expected_freq_reg ^ freq_reg ^ expected_freq_reg)) begin
                $display("PASS");
                $display("  Outputs: freq_reg=%h",
                         freq_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_reg=%h",
                         expected_freq_reg);
                $display("  Got:      freq_reg=%h",
                         freq_reg);
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
        $dumpvars(0,ch_c, sys_clk_50m, sys_rst_n, freq_reg);
    end

endmodule
