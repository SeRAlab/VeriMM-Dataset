`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_signal;
    reg reset;
    reg valid;
    wire [3:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .input_signal(input_signal),
        .reset(reset),
        .valid(valid),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            input_signal = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic operation - 2 valid cycles");
            reset_dut();

            @(posedge clk);
            #1 input_signal = 4'hA; valid = 1;

            @(posedge clk);
            #1 input_signal = 4'hB; valid = 1;
            @(posedge clk);
            #1 valid = 0;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Four valid cycles");
            reset_dut();

            @(posedge clk);
            #1 input_signal = 4'h1; valid = 1;
            @(posedge clk);
            #1 input_signal = 4'h2; valid = 1;

            @(posedge clk);
            #1 input_signal = 4'h3; valid = 1;
            @(posedge clk);
            #1 input_signal = 4'h4; valid = 1;
            @(posedge clk);
            #1 valid = 0;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Intermittent valid signals");
            reset_dut();

            @(posedge clk);
            #1 input_signal = 4'h5; valid = 1;

            @(posedge clk);
            #1 input_signal = 4'hF; valid = 0;
            @(posedge clk);
            #1 input_signal = 4'hE; valid = 0;

            @(posedge clk);
            #1 input_signal = 4'h6; valid = 1;
            @(posedge clk);
            #1 valid = 0;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Odd number of valid cycles");
            reset_dut();

            @(posedge clk);
            #1 input_signal = 4'h1; valid = 1;
            @(posedge clk);
            #1 input_signal = 4'h2; valid = 1;

            @(posedge clk);
            #1 input_signal = 4'h3; valid = 1;
            @(posedge clk);
            #1 valid = 0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Reset during operation");
            reset_dut();

            @(posedge clk);
            #1 input_signal = 4'h7; valid = 1;

            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1 input_signal = 4'h8; valid = 1;
            @(posedge clk);
            #1 input_signal = 4'h9; valid = 1;
            @(posedge clk);
            #1 valid = 0;
            #1;

            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [3:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, input_signal, reset, valid, output_signal);
    end

endmodule
