`timescale 1ns/1ps

module EchoCancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] echo_signal;
    reg [15:0] input_signal;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EchoCancellation dut (
        .clk(clk),
        .echo_signal(echo_signal),
        .input_signal(input_signal),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_signal = 16'h0;
            echo_signal = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            input_signal = 16'd1000;
            echo_signal  = 16'd250;
            @(posedge clk);
            #2;
            $display("Test Case 001: 1000 - 250");
            #1;

            check_outputs(16'd750);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input_signal = 16'hABCD;
            echo_signal  = 16'hABCD;
            @(posedge clk);
            #2;
            $display("Test Case 002: hABCD - hABCD");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input_signal = 16'h5555;
            echo_signal  = 16'h0000;
            @(posedge clk);
            #2;
            $display("Test Case 003: h5555 - 0");
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input_signal = 16'd10;
            echo_signal  = 16'd20;
            @(posedge clk);
            #2;
            $display("Test Case 004: 10 - 20 (Underflow)");
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input_signal = 16'hFFFF;
            echo_signal  = 16'h0001;
            @(posedge clk);
            #2;
            $display("Test Case 005: hFFFF - 1");
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            input_signal = 16'h0000;
            echo_signal  = 16'h0001;
            @(posedge clk);
            #2;
            $display("Test Case 006: 0 - 1 (Underflow)");
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("EchoCancellation Testbench");
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
        input [15:0] expected_output_signal;
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
        $dumpvars(0,clk, echo_signal, input_signal, output_signal);
    end

endmodule
