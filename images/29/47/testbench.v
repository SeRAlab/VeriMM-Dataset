`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [15:0] fraction;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .fraction(fraction),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

    begin
        $display("Resetting PLL state...");
        fraction = 16'h0000;
        #200;
    end
        endtask
    task verify_frequency;

        input real target_period;
        begin

            #100;

            @(posedge clk_out);
            t1 = $realtime;
            repeat(10) @(posedge clk_out);
            t2 = $realtime;
            measured_period = (t2 - t1) / 10.0;

            tolerance = target_period * 0.02;

            if (abs_diff(measured_period, target_period) < tolerance) begin
                #1;

                check_outputs(clk_out);
            end else begin
                $display("Frequency Error: Expected period %0.3fns, Measured %0.3fns", target_period, measured_period);
                #1;

                check_outputs(~clk_out);
            end
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Integer Multiplier N=2.0", test_num);
        reset_dut();
        fraction = 16'h0200;
        expected_period = 10.0 / 2.0;
        #5000;
        verify_frequency(expected_period);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Fractional Multiplier N=4.5", test_num);
        reset_dut();
        fraction = 16'h0480;
        expected_period = 10.0 / 4.5;
        #5000;
        verify_frequency(expected_period);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Fractional Multiplier N=1.25", test_num);
        reset_dut();
        fraction = 16'h0140;
        expected_period = 10.0 / 1.25;
        #5000;
        verify_frequency(expected_period);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: High Multiplier N=8.75", test_num);
        reset_dut();
        fraction = 16'h08C0;
        expected_period = 10.0 / 8.75;
        #5000;
        verify_frequency(expected_period);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        $dumpvars(0,clk_ref, fraction, clk_out);
    end

endmodule
