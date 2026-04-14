`timescale 1ns/1ps

module EchoCancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_signal;
    reg [15:0] reference_signal;
    reg rst;
    wire [15:0] output_signal;
    wire status;

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
        .output_signal(output_signal),
        .status(status)
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
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Signal without Echo", test_num);
            reset_dut();
            @(negedge clk);
            input_signal = 16'hA5A5;
            reference_signal = 16'h0000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hA5A5, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Pure Echo Cancellation", test_num);
            reset_dut();
            @(negedge clk);
            input_signal = 16'h1234;
            reference_signal = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Standard Subtraction Logic", test_num);
            reset_dut();
            @(negedge clk);
            input_signal = 16'h5000;
            reference_signal = 16'h1000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4000, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Signed Subtraction", test_num);
            reset_dut();
            @(negedge clk);
            input_signal = 16'h0005;
            reference_signal = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0006, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Values", test_num);
            reset_dut();
            @(negedge clk);
            input_signal = 16'hFFFF;
            reference_signal = 16'h7FFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8000, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multi-cycle Operation", test_num);
            reset_dut();
            repeat(5) begin
                @(negedge clk);
                input_signal = input_signal + 16'h0100;
                reference_signal = 16'h0050;
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h04B0, 1);
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
        input expected_status;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h, status=%b",
                         output_signal, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h, status=%b",
                         expected_output_signal, expected_status);
                $display("  Got:      output_signal=%h, status=%b",
                         output_signal, status);
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
        $dumpvars(0,clk, input_signal, reference_signal, rst, output_signal, status);
    end

endmodule
