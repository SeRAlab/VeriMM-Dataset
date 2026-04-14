`timescale 1ns/1ps

module EchoCancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_signal;
    reg [15:0] delayed_signal;
    reg rst;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EchoCancellation dut (
        .clk(clk),
        .current_signal(current_signal),
        .delayed_signal(delayed_signal),
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
            current_signal = 16'd0;
            delayed_signal = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Subtraction", test_num);
            reset_dut();
            current_signal = 16'h00FF;
            delayed_signal = 16'h0055;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h00AA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: No Echo (Delayed Signal = 0)", test_num);
            reset_dut();
            current_signal = 16'hABCD;
            delayed_signal = 16'h0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Perfect Cancellation", test_num);
            reset_dut();
            current_signal = 16'h5555;
            delayed_signal = 16'h5555;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Underflow Scenario", test_num);
            reset_dut();
            current_signal = 16'h0010;
            delayed_signal = 16'h0020;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'hFFF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Boundary Values (Maximums)", test_num);
            reset_dut();
            current_signal = 16'hFFFF;
            delayed_signal = 16'h0001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Full Range Subtraction", test_num);
            reset_dut();
            current_signal = 16'hFFFF;
            delayed_signal = 16'hFFFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Rapid Signal Change", test_num);
            reset_dut();

            current_signal = 16'h1000;
            delayed_signal = 16'h0100;
            repeat(2) @(posedge clk);

            current_signal = 16'h2000;
            delayed_signal = 16'h0200;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h1E00);
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
        $dumpvars(0,clk, current_signal, delayed_signal, rst, output_signal);
    end

endmodule
