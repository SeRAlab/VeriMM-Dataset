`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 2'b00;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            control = 2'b00;
            data_in = 16'hA5A5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            control = 2'b01;
            data_in = 16'hF0F0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0F0F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            control = 2'b10;
            data_in = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            control = 2'b11;
            data_in = 16'h0002;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            control = 2'b01;
            data_in = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            control = 2'b10;
            data_in = 16'h8001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            control = 2'b11;
            data_in = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            control = 2'b00;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, control, data_in, data_out);
    end

endmodule
