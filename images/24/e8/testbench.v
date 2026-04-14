`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] conversion_ratio;
    reg [7:0] input_signal;
    reg reset;
    wire [7:0] output_signal;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .conversion_ratio(conversion_ratio),
        .input_signal(input_signal),
        .reset(reset),
        .output_signal(output_signal),
        .output_valid(output_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            conversion_ratio = 0;
            input_signal = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 1:1 (Direct Pass-through)", test_num);
            reset_dut();
            conversion_ratio = 4'd1;
            input_signal = 8'hA5;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 2:1 (Downsampling)", test_num);
            reset_dut();
            conversion_ratio = 4'd2;
            input_signal = 8'h10; @(posedge clk);
            input_signal = 8'h20; @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h20, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 4:1 (Heavy Downsampling)", test_num);
            reset_dut();
            conversion_ratio = 4'd4;
            input_signal = 8'h01; @(posedge clk);
            input_signal = 8'h02; @(posedge clk);
            input_signal = 8'h03; @(posedge clk);
            input_signal = 8'h04; @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h04, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 0 (Potential High-Rate/Bypass Mode)", test_num);
            reset_dut();
            conversion_ratio = 4'd0;
            input_signal = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 3:1 (Odd Downsampling Ratio)", test_num);
            reset_dut();
            conversion_ratio = 4'd3;
            input_signal = 8'hAA; @(posedge clk);
            input_signal = 8'hBB; @(posedge clk);
            input_signal = 8'hCC; @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'hCC, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input expected_output_valid;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h, output_valid=%b",
                         output_signal, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h, output_valid=%b",
                         expected_output_signal, expected_output_valid);
                $display("  Got:      output_signal=%h, output_valid=%b",
                         output_signal, output_valid);
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
        $dumpvars(0,clk, conversion_ratio, input_signal, reset, output_signal, output_valid);
    end

endmodule
