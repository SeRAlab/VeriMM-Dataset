`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control_word;
    wire [7:0] output_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .control_word(control_word),
        .output_freq(output_freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control_word = 3'b000;

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Control Word = 0", test_num);
            reset_dut();
            control_word = 3'd0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd0 * FACTOR);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Control Word = 1", test_num);
            reset_dut();
            control_word = 3'd1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd1 * FACTOR);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Control Word = 4", test_num);
            reset_dut();
            control_word = 3'd4;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd4 * FACTOR);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Control Word = 7", test_num);
            reset_dut();
            control_word = 3'd7;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd7 * FACTOR);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Control Word = 2", test_num);
            reset_dut();
            control_word = 3'd2;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd2 * FACTOR);
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
        input [7:0] expected_output_freq;
        begin
            if (expected_output_freq === (expected_output_freq ^ output_freq ^ expected_output_freq)) begin
                $display("PASS");
                $display("  Outputs: output_freq=%h",
                         output_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_freq=%h",
                         expected_output_freq);
                $display("  Got:      output_freq=%h",
                         output_freq);
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
        $dumpvars(0,clk, control_word, output_freq);
    end

endmodule
