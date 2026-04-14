`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg [7:0] data_parallel;
    reg load;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_parallel(data_parallel),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            data_parallel = 8'h00;
            data_in = 0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            load = 1;
            data_parallel = 8'hAA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            load = 1;
            data_parallel = 8'hFF;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            load = 0;
            data_in = 1;
            @(negedge clk);

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge clk);
            load = 1;
            data_parallel = 8'h01;
            @(negedge clk);
            load = 0;
            data_in = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            load = 0;
            data_in = 1; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            #1;

            check_outputs(8'h0D);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(negedge clk);
            load = 1;
            data_parallel = 8'h80;
            @(negedge clk);
            load = 0;
            data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();
            @(negedge clk);
            load = 0;
            data_in = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
            end

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_parallel, load, data_out);
    end

endmodule
