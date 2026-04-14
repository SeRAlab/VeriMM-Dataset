`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_signal;
    reg reset;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .input_signal(input_signal),
        .reset(reset),
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
            input_signal = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic subtraction (25 - 10)");
            reset_dut();
            input_signal = 8'd10;
            @(posedge clk);
            input_signal = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Constant input (50 - 50)");
            reset_dut();
            input_signal = 8'd50;
            @(posedge clk);
            input_signal = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Negative result wrap-around (10 - 40)");
            reset_dut();
            input_signal = 8'd40;
            @(posedge clk);
            input_signal = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hE2);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Maximum step (255 - 0)");
            reset_dut();
            input_signal = 8'h00;
            @(posedge clk);
            input_signal = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Post-reset first sample (100 - 0)");
            reset_dut();
            input_signal = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
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
        input [7:0] expected_output_signal;
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
        $dumpvars(0,clk, input_signal, reset, output_signal);
    end

endmodule
