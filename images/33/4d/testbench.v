`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_signal;
    reg [7:0] input_signal;
    reg reset;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .clk(clk),
        .control_signal(control_signal),
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
            control_signal = 0;
            input_signal = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Bypass Mode (Control Low, Input=8'd100)");
            reset_dut();
            control_signal = 0;
            input_signal = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Compression Mode (Control High, Input=8'd100, Ratio=2)");
            reset_dut();
            control_signal = 1;
            input_signal = 8'd100;
            @(posedge clk);

            #1 #1;
 check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Compression Mode (Control High, Input=8'd254, Ratio=2)");
            reset_dut();
            control_signal = 1;
            input_signal = 8'd254;
            @(posedge clk);

            #1 #1;
 check_outputs(8'd127);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Bypass Mode (Control Low, Input=8'd255)");
            reset_dut();
            control_signal = 0;
            input_signal = 8'd255;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Compression Mode (Control High, Input=8'd10, Ratio=2)");
            reset_dut();
            control_signal = 1;
            input_signal = 8'd10;
            @(posedge clk);

            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Reset State Output Verification");
            reset = 1;
            control_signal = 1;
            input_signal = 8'd200;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        $dumpvars(0,clk, control_signal, input_signal, reset, output_signal);
    end

endmodule
