`timescale 1ns/1ps

module echo_cancel_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] delayed_signal;
    reg [7:0] input_signal;
    reg rst;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancel dut (
        .clk(clk),
        .delayed_signal(delayed_signal),
        .input_signal(input_signal),
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
            delayed_signal = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Subtraction (Input=20, Delay=0)", test_num);
            reset_dut();
            input_signal = 8'd20;
            delayed_signal = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Perfect Cancellation (Input=50, Delay=50)", test_num);
            reset_dut();
            input_signal = 8'd50;
            delayed_signal = 8'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Partial Cancellation (Input=100, Delay=30)", test_num);
            reset_dut();
            input_signal = 8'd100;
            delayed_signal = 8'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Underflow (Input=10, Delay=20)", test_num);
            reset_dut();
            input_signal = 8'd10;
            delayed_signal = 8'd20;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Max Values (Input=255, Delay=1)", test_num);
            reset_dut();
            input_signal = 8'hFF;
            delayed_signal = 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();
            input_signal = 8'h00;
            delayed_signal = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Large Delta (Input=200, Delay=5)", test_num);
            reset_dut();
            input_signal = 8'd200;
            delayed_signal = 8'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd195);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancel Testbench");
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
        $dumpvars(0,clk, delayed_signal, input_signal, rst, output_signal);
    end

endmodule
