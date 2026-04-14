`timescale 1ns/1ps

module dpcm_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_sample;
    reg reset;
    wire [7:0] error_signal;
    wire [7:0] predicted_sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dpcm_encoder dut (
        .clk(clk),
        .current_sample(current_sample),
        .reset(reset),
        .error_signal(error_signal),
        .predicted_sample(predicted_sample)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_sample = 8'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Positive Difference", test_num);
            reset_dut();

            current_sample = 8'd50;
            @(posedge clk);
            #1;

            current_sample = 8'd70;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd20, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Difference", test_num);
            reset_dut();

            current_sample = 8'd100;
            @(posedge clk);
            #1;

            current_sample = 8'd100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd0, 8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Difference", test_num);
            reset_dut();

            current_sample = 8'd150;
            @(posedge clk);
            #1;

            current_sample = 8'd100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCE, 8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Scale Jump", test_num);
            reset_dut();

            current_sample = 8'd0;
            @(posedge clk);
            #1;

            current_sample = 8'd255;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrapping Subtraction", test_num);
            reset_dut();

            current_sample = 8'd255;
            @(posedge clk);
            #1;

            current_sample = 8'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-step Sequence", test_num);
            reset_dut();

            current_sample = 8'd10;
            @(posedge clk);
            #1;

            current_sample = 8'd20;
            @(posedge clk);
            #1;

            current_sample = 8'd35;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd15, 8'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dpcm_encoder Testbench");
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
        input [7:0] expected_error_signal;
        input [7:0] expected_predicted_sample;
        begin
            if (expected_error_signal === (expected_error_signal ^ error_signal ^ expected_error_signal) &&
                expected_predicted_sample === (expected_predicted_sample ^ predicted_sample ^ expected_predicted_sample)) begin
                $display("PASS");
                $display("  Outputs: error_signal=%h, predicted_sample=%h",
                         error_signal, predicted_sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_signal=%h, predicted_sample=%h",
                         expected_error_signal, expected_predicted_sample);
                $display("  Got:      error_signal=%h, predicted_sample=%h",
                         error_signal, predicted_sample);
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
        $dumpvars(0,clk, current_sample, reset, error_signal, predicted_sample);
    end

endmodule
