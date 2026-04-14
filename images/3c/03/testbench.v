`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_signal;
    reg [9:0] rate_change;
    reg reset;
    wire [7:0] output_signal;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .input_signal(input_signal),
        .rate_change(rate_change),
        .reset(reset),
        .output_signal(output_signal),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_signal = 0;
            rate_change = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Downsampling (Skip 1)", test_num);
            reset_dut();
            rate_change = 10'd1;

            input_signal = 8'hA1; @(posedge clk);
            input_signal = 8'hA2; @(posedge clk);
            input_signal = 8'hA3; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hA3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Downsampling (Skip 2)", test_num);
            reset_dut();
            rate_change = 10'd2;

            input_signal = 8'hB1; @(posedge clk);
            input_signal = 8'hB2; @(posedge clk);
            input_signal = 8'hB3; @(posedge clk);
            input_signal = 8'hB4; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hB4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Upsampling (Repeat 1)", test_num);
            reset_dut();
            rate_change = 10'h201;

            input_signal = 8'hC1; @(posedge clk);
            input_signal = 8'hFF; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hC1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Upsampling (Repeat 2)", test_num);
            reset_dut();
            rate_change = 10'h202;

            input_signal = 8'hD1; @(posedge clk);
            input_signal = 8'h00; @(posedge clk);
            input_signal = 8'h00; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hD1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Passthrough (Skip 0)", test_num);
            reset_dut();
            rate_change = 10'd0;

            input_signal = 8'hE1; @(posedge clk);
            input_signal = 8'hE2; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hE2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Downsampling Valid Check", test_num);
            reset_dut();
            rate_change = 10'd1;

            input_signal = 8'hF1; @(posedge clk);
            input_signal = 8'hF2; @(posedge clk);

            #1;

            #1;


            check_outputs(output_signal, 1'b0);
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
        input expected_valid;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h, valid=%b",
                         output_signal, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h, valid=%b",
                         expected_output_signal, expected_valid);
                $display("  Got:      output_signal=%h, valid=%b",
                         output_signal, valid);
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
        $dumpvars(0,clk, input_signal, rate_change, reset, output_signal, valid);
    end

endmodule
