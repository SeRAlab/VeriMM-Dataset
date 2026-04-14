`timescale 1ns/1ps

module fractional_n_PLL_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg [7:0] N;
    reg clk_ref;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_PLL dut (
        .D(D),
        .N(N),
        .clk_ref(clk_ref),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            D = 8'd0;
            N = 8'd0;
            #20;
        end
        endtask
    task verify_frequency;

        input real expected_T;
        begin

            #500;

            @(posedge clk_out);
            t_start = $realtime;
            repeat(10) @(posedge clk_out);
            t_end = $realtime;

            measured_period = (t_end - t_start) / 10.0;
            tolerance = 0.05;

            if (measured_period >= (expected_T - tolerance) && measured_period <= (expected_T + tolerance)) begin
                #1;

                check_outputs(clk_out);
            end else begin
                $display("Frequency mismatch: Expected Period %0.3fns, Measured %0.3fns", expected_T, measured_period);
                #1;

                check_outputs(~clk_out);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integer Multiplier N=2, D=0", test_num);
            reset_dut();
            N = 8'd2;
            D = 8'd0;
            verify_frequency(5.0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integer Multiplier N=4, D=0", test_num);
            reset_dut();
            N = 8'd4;
            D = 8'd0;
            verify_frequency(2.5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fractional Multiplier N=2, D=128 (2.5x)", test_num);
            reset_dut();
            N = 8'd2;
            D = 8'd128;
            verify_frequency(4.0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fractional Multiplier N=1, D=64 (1.25x)", test_num);
            reset_dut();
            N = 8'd1;
            D = 8'd64;
            verify_frequency(8.0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_PLL Testbench");
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
        $dumpvars(0,D, N, clk_ref, clk_out);
    end

endmodule
