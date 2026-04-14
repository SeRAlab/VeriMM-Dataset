`timescale 1ns/1ps

module cnn_convolution_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [24:0] input_data;
    reg [8:0] kernel;
    reg reset;
    wire [15:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cnn_convolution dut (
        .clk(clk),
        .input_data(input_data),
        .kernel(kernel),
        .reset(reset),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_data = 0;
            kernel = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            input_data = 25'b0;
            kernel = 9'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            input_data = 25'h0001CE7;
            kernel = 9'h1FF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            input_data = (1 << 6);
            kernel = (1 << 4);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            input_data = 25'h0001CE7;
            kernel = 9'b100_010_001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            input_data = 25'h1001CF7;
            kernel = 9'h1FF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cnn_convolution Testbench");
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
        input [15:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, input_data, kernel, reset, output_data);
    end

endmodule
