`timescale 1ns/1ps

module EchoCancellation_tb;

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
    EchoCancellation dut (
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
            input_signal = 0;
            reference_signal = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction (1000 - 200)", test_num);
            reset_dut();
            input_signal = 16'd1000;
            reference_signal = 16'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd800);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical Signals (500 - 500)", test_num);
            reset_dut();
            input_signal = 16'd500;
            reference_signal = 16'd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow/Negative Result (10 - 20)", test_num);
            reset_dut();
            input_signal = 16'd10;
            reference_signal = 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Value Subtraction (0xFFFF - 0x0001)", test_num);
            reset_dut();
            input_signal = 16'hFFFF;
            reference_signal = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input (0 - 123)", test_num);
            reset_dut();
            input_signal = 16'd0;
            reference_signal = 16'd123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0 - 16'd123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior Verification", test_num);
            reset_dut();
            input_signal = 16'hAAAA;
            reference_signal = 16'h5555;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
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
        $dumpvars(0,clk, input_signal, reference_signal, rst, output_signal);
    end

endmodule
