`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_signal;
    reg rst;
    wire [31:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
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
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Input", test_num);
            reset_dut();
            repeat(32) begin
                input_signal = 16'h0000;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Unit Step Response", test_num);
            reset_dut();
            repeat(32) begin
                input_signal = 16'h0001;
                @(posedge clk);
            end

            #1 #1;
 check_outputs(32'h00000020);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Impulse Response Propagation", test_num);
            reset_dut();
            input_signal = 16'h000A;
            @(posedge clk);
            repeat(31) begin
                input_signal = 16'h0000;
                @(posedge clk);
            end


            #1 #1;
 check_outputs(32'h0000000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: DC Gain (Constant 100)", test_num);
            reset_dut();
            repeat(32) begin
                input_signal = 16'd100;
                @(posedge clk);
            end

            #1 #1;
 check_outputs(32'd3200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Ramp Input", test_num);
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                input_signal = i;
                @(posedge clk);
            end

            #1 #1;
 check_outputs(32'd496);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [31:0] expected_output_signal;
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
        $dumpvars(0,clk, input_signal, rst, output_signal);
    end

endmodule
