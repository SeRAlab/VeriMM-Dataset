`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_signal;
    reg [15:0] reference_signal;
    reg rst;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .input_signal(input_signal),
        .reference_signal(reference_signal),
        .rst(rst),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_signal = 16'd0;
            reference_signal = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Zero inputs");
            reset_dut();
            input_signal = 16'h0000;
            reference_signal = 16'h0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Signal without echo");
            reset_dut();
            input_signal = 16'h1234;
            reference_signal = 16'h0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Simple echo cancellation");
            reset_dut();
            input_signal = 16'h5000;
            reference_signal = 16'h1000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Perfect cancellation");
            reset_dut();
            input_signal = 16'hAAAA;
            reference_signal = 16'hAAAA;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Large values");
            reset_dut();
            input_signal = 16'hFFFF;
            reference_signal = 16'h8000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reference larger than input (Wrap-around)");
            reset_dut();
            input_signal = 16'h0010;
            reference_signal = 16'h0020;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Small signal change");
            reset_dut();
            input_signal = 16'd1000;
            reference_signal = 16'd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd999);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, input_signal, reference_signal, rst, output_signal);
    end

endmodule
