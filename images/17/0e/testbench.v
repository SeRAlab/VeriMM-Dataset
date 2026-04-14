`timescale 1ns/1ps

module PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg ref_freq;
    wire out_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL dut (
        .clk(clk),
        .control(control),
        .ref_freq(ref_freq),
        .out_freq(out_freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        $display("Resetting system...");
        control = 0;
        ref_gen_en = 0;
        #100;
        control = 1;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: No Reference Frequency", test_num);
        reset_dut();
        ref_gen_en = 0;
        #1000;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Lock to 50MHz (20ns period)", test_num);
        reset_dut();
        ref_period = 20.0;
        ref_gen_en = 1;


        #10000;



        wait(ref_freq == 1'b1);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Lock to 25MHz (40ns period)", test_num);
        reset_dut();
        ref_period = 40.0;
        ref_gen_en = 1;

        #15000;

        wait(ref_freq == 1'b1);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Disable PLL using Control", test_num);
        reset_dut();
        ref_period = 20.0;
        ref_gen_en = 1;
        #5000;

        control = 0;
        #1000;


        #1;



        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_out_freq;
        begin
            if (expected_out_freq === (expected_out_freq ^ out_freq ^ expected_out_freq)) begin
                $display("PASS");
                $display("  Outputs: out_freq=%b",
                         out_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_freq=%b",
                         expected_out_freq);
                $display("  Got:      out_freq=%b",
                         out_freq);
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
        $dumpvars(0,clk, control, ref_freq, out_freq);
    end

endmodule
