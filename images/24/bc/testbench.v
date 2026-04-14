`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg ref_freq;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk_in(clk_in),
        .ref_freq(ref_freq),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting system and initializing reference...");
            ref_freq = 0;
            #100;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tracking 1 MHz Reference", test_num);
            reset_dut();


            for (i = 0; i < 200; i = i + 1) begin
                ref_freq = 1;
                #500;
                ref_freq = 0;
                #500;
            end



            ref_freq = 1;
            #250;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tracking 2 MHz Reference", test_num);
            reset_dut();

            for (i = 0; i < 400; i = i + 1) begin
                ref_freq = 1;
                #250;
                ref_freq = 0;
                #250;
            end

            ref_freq = 1;
            #125;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tracking 500 kHz Reference", test_num);
            reset_dut();

            for (i = 0; i < 100; i = i + 1) begin
                ref_freq = 1;
                #1000;
                ref_freq = 0;
                #1000;
            end

            ref_freq = 0;
            #500;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Frequency Step Response (1MHz -> 1.25MHz)", test_num);
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                ref_freq = 1; #500; ref_freq = 0; #500;
            end


            for (i = 0; i < 150; i = i + 1) begin
                ref_freq = 1; #400; ref_freq = 0; #400;
            end

            ref_freq = 1;
            #200;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll Testbench");
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
        $dumpvars(0,clk_in, ref_freq, clk_out);
    end

endmodule
