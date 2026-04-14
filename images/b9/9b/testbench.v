`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_data;
    reg parallel_load;
    reg reset;
    reg shift;
    wire [3:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data(input_data),
        .parallel_load(parallel_load),
        .reset(reset),
        .shift(shift),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            parallel_load = 0;
            shift = 0;
            input_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            parallel_load = 1;
            input_data = 4'b1011;
            @(posedge clk);
            #1;
            parallel_load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clk);
            parallel_load = 1;
            input_data = 4'b0001;
            @(posedge clk);

            @(negedge clk);
            parallel_load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            parallel_load = 1;
            input_data = 4'b0011;
            @(posedge clk);

            @(negedge clk);
            parallel_load = 0;
            shift = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            shift = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk);
            parallel_load = 1;
            shift = 1;
            input_data = 4'b0101;
            @(posedge clk);
            #1;
            parallel_load = 0;
            shift = 0;

            #1;


            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            reset = 1;
            parallel_load = 1;
            input_data = 4'b1111;
            @(posedge clk);
            #1;
            reset = 0;
            parallel_load = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            @(negedge clk);
            parallel_load = 1;
            input_data = 4'b1000;
            @(posedge clk);

            @(negedge clk);
            parallel_load = 0;
            shift = 1;
            repeat(4) @(posedge clk);
            #1;
            shift = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            @(negedge clk);
            parallel_load = 1;
            input_data = 4'b1101;
            @(posedge clk);

            @(negedge clk);
            parallel_load = 0;
            shift = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_output_data;
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
        $dumpvars(0,clk, input_data, parallel_load, reset, shift, output_data);
    end

endmodule
