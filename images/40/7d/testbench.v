`timescale 1ns/1ps

module noise_suppression_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] noisy_input;
    reg rst;
    wire [4:0] clean_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression_filter dut (
        .clk(clk),
        .noisy_input(noisy_input),
        .rst(rst),
        .clean_output(clean_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            rst = 1;
            noisy_input = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: All Zeros");
            reset_dut();
            noisy_input = 5'b00000; @(posedge clk);
            noisy_input = 5'b00000; @(posedge clk);
            noisy_input = 5'b00000; @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: All Ones");
            reset_dut();
            noisy_input = 5'b11111; @(posedge clk);
            noisy_input = 5'b11111; @(posedge clk);
            noisy_input = 5'b11111; @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Single Noise Spike Suppression");
            reset_dut();
            noisy_input = 5'b00000; @(posedge clk);
            noisy_input = 5'b11111; @(posedge clk);
            noisy_input = 5'b00000; @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Sustained Transition");
            reset_dut();
            noisy_input = 5'b00000; @(posedge clk);
            noisy_input = 5'b11111; @(posedge clk);
            noisy_input = 5'b11111; @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mixed Bit Majority");
            reset_dut();
            noisy_input = 5'b10101; @(posedge clk);
            noisy_input = 5'b11110; @(posedge clk);
            noisy_input = 5'b10001; @(posedge clk);
            #1;






            #1;







            check_outputs(5'b10101);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Reset History Check");
            reset_dut();
            noisy_input = 5'b11111; @(posedge clk);
            noisy_input = 5'b11111; @(posedge clk);


            rst = 1; @(posedge clk);
            #1 rst = 0;

            noisy_input = 5'b11111; @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression_filter Testbench");
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
        input [4:0] expected_clean_output;
        begin
            if (expected_clean_output === (expected_clean_output ^ clean_output ^ expected_clean_output)) begin
                $display("PASS");
                $display("  Outputs: clean_output=%h",
                         clean_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_output=%h",
                         expected_clean_output);
                $display("  Got:      clean_output=%h",
                         clean_output);
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
        $dumpvars(0,clk, noisy_input, rst, clean_output);
    end

endmodule
