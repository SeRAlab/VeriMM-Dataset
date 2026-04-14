`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] echo_signal;
    reg [7:0] input_signal;
    reg reset;
    wire [7:0] clean_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .echo_signal(echo_signal),
        .input_signal(input_signal),
        .reset(reset),
        .clean_signal(clean_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            input_signal = 0;
            echo_signal = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Subtraction (50 - 10)");
            reset_dut();
            input_signal = 8'd50;
            echo_signal = 8'd10;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Subtraction resulting in zero (100 - 100)");
            reset_dut();
            input_signal = 8'd100;
            echo_signal = 8'd100;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: No echo cancellation (255 - 0)");
            reset_dut();
            input_signal = 8'd255;
            echo_signal = 8'd0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Negative result wraparound (10 - 20)");
            reset_dut();
            input_signal = 8'd10;
            echo_signal = 8'd20;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Maximum input values (255 - 255)");
            reset_dut();
            input_signal = 8'd255;
            echo_signal = 8'd255;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset assertion check");
            reset_dut();
            input_signal = 8'd100;
            echo_signal = 8'd10;

            reset = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
            reset = 0;
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
        input [7:0] expected_clean_signal;
        begin
            if (expected_clean_signal === (expected_clean_signal ^ clean_signal ^ expected_clean_signal)) begin
                $display("PASS");
                $display("  Outputs: clean_signal=%h",
                         clean_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_signal=%h",
                         expected_clean_signal);
                $display("  Got:      clean_signal=%h",
                         clean_signal);
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
        $dumpvars(0,clk, echo_signal, input_signal, reset, clean_signal);
    end

endmodule
