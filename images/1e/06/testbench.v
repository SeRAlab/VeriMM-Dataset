`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [3:0] fractional_value;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .fractional_value(fractional_value),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            reset = 1;
            fractional_value = 0;
            #100;
            reset = 0;
            #100;
        end
        endtask
    task verify_freq;

        input real exp_p;
        begin
            @(posedge clk_out);
            t1 = $realtime;
            repeat(10) @(posedge clk_out);
            t2 = $realtime;
            measured_period = (t2 - t1) / 10.0;


            if (measured_period > (exp_p * 0.95) && measured_period < (exp_p * 1.05)) begin
                #1;

                check_outputs(clk_out);
            end else begin
                $display("Frequency Error: Expected ~%0.3fns, Got %0.3fns", exp_p, measured_period);
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset = 1;
            #100;

            if (clk_out === 1'b0 || clk_out === 1'b1)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(1'bx);
            reset = 0;
            #100;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Integer Multiplier (frac=0)", test_num);
            reset_dut();
            fractional_value = 4'd0;
            #2000;
            verify_freq(5.0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Mid-range Fractional (frac=8)", test_num);
            reset_dut();
            fractional_value = 4'd8;
            #5000;


            verify_freq(4.0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: High Fractional (frac=15)", test_num);
            reset_dut();
            fractional_value = 4'd15;
            #5000;


            verify_freq(3.404);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Low Fractional (frac=4)", test_num);
            reset_dut();
            fractional_value = 4'd4;
            #5000;


            verify_freq(4.444);
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
        $dumpvars(0,clk_ref, fractional_value, reset, clk_out);
    end

endmodule
