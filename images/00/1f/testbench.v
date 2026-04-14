`timescale 1ns/1ps

module crystal_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] freq_div;
    wire osc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crystal_oscillator dut (
        .clk(clk),
        .freq_div(freq_div),
        .osc_out(osc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: freq_div = 1 (Toggle every cycle)");
            freq_div = 4'd1;
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: freq_div = 2 (Toggle every 2 cycles)");
            freq_div = 4'd2;
            reset_dut();

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: freq_div = 2 (Check phase after 4 cycles)");
            freq_div = 4'd2;
            reset_dut();

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: freq_div = 4 (Toggle every 4 cycles)");
            freq_div = 4'd4;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: freq_div = 5 (Check cycle completion)");
            freq_div = 4'd5;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
            repeat(5) @(posedge clk);
            #1;
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
        $display("crystal_oscillator Testbench");
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
        input expected_osc_out;
        begin
            if (expected_osc_out === (expected_osc_out ^ osc_out ^ expected_osc_out)) begin
                $display("PASS");
                $display("  Outputs: osc_out=%b",
                         osc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: osc_out=%b",
                         expected_osc_out);
                $display("  Got:      osc_out=%b",
                         osc_out);
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
        $dumpvars(0,clk, freq_div, osc_out);
    end

endmodule
