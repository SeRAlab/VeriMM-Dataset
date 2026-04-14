`timescale 1ns/1ps

module debounce_tb;

    // Testbench signals (sequential circuit)
    reg button_in;
    reg clk;
    reg rst;
    wire button_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debounce dut (
        .button_in(button_in),
        .clk(clk),
        .rst(rst),
        .button_out(button_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            button_in = 0;
            #(CLK_PERIOD * 2);
            rst = 0;
            #(CLK_PERIOD * 2);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Stable High Input");
            reset_dut();
            button_in = 1;

            repeat (DEBOUNCE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Short Noise Glitch");
            reset_dut();
            button_in = 1;
            repeat (DEBOUNCE_TIME / 2) @(posedge clk);
            button_in = 0;
            repeat (DEBOUNCE_TIME / 2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Stable High then Stable Low");
            reset_dut();

            button_in = 1;
            repeat (DEBOUNCE_TIME + 10) @(posedge clk);

            button_in = 0;
            repeat (DEBOUNCE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Jitter followed by stable signal");
            reset_dut();

            repeat (5) begin
                button_in = 1; #(CLK_PERIOD * 10);
                button_in = 0; #(CLK_PERIOD * 10);
            end

            button_in = 1;
            repeat (DEBOUNCE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset mid-operation");
            reset_dut();
            button_in = 1;
            repeat (DEBOUNCE_TIME + 10) @(posedge clk);

            if (button_out !== 1'b1) $display("Error: Pre-condition high failed");

            rst = 1;
            #(CLK_PERIOD * 2);
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("debounce Testbench");
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
        input expected_button_out;
        begin
            if (expected_button_out === (expected_button_out ^ button_out ^ expected_button_out)) begin
                $display("PASS");
                $display("  Outputs: button_out=%b",
                         button_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: button_out=%b",
                         expected_button_out);
                $display("  Got:      button_out=%b",
                         button_out);
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
        $dumpvars(0,button_in, clk, rst, button_out);
    end

endmodule
