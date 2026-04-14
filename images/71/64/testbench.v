`timescale 1ns/1ps

module async_down_counter_wrap_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg enable;
    wire [5:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    async_down_counter_wrap dut (
        .async_reset(async_reset),
        .clk(clk),
        .enable(enable),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        async_reset = 0;
        forever #5 async_reset = ~async_reset;
    end

        task reset_dut;

        begin
            async_reset = 1;
            enable = 0;
            #15;
            async_reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            reset_dut();
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Testing Wrap Around (0 -> 63)");
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd63);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Counting down 5 steps");
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(6'd59);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Testing Enable de-assertion");
            reset_dut();
            enable = 1;
            repeat (2) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd62);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full rotation (64 steps)");
            reset_dut();
            enable = 1;
            repeat (64) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Asynchronous reset mid-cycle");
            reset_dut();
            enable = 1;
            repeat (10) @(posedge clk);
            #3;
            async_reset = 1;
            #2;
            #1;

            check_outputs(6'd0);
            async_reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("async_down_counter_wrap Testbench");
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
        input [5:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,async_reset, clk, enable, count_out);
    end

endmodule
