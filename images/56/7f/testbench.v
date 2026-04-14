`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg shift_mode;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_mode(shift_mode),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            data_in = 8'h00;
            shift_mode = 0;
            @(posedge clk);
            #1;
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Shift Right Full (1s)");
            reset_dut();
            shift_mode = 0;
            data_in = 8'hFF;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Shift Left Full (1s)");
            reset_dut();
            shift_mode = 1;
            data_in = 8'hFF;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Partial Shift Right (4 bits)");
            reset_dut();
            shift_mode = 0;
            data_in = 8'hFF;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Partial Shift Left (4 bits)");
            reset_dut();
            shift_mode = 1;
            data_in = 8'hFF;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Fill and Clear Right");
            reset_dut();
            shift_mode = 0;
            data_in = 8'hFF;
            repeat(8) @(posedge clk);
            data_in = 8'h00;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase 007: Fill and Clear Left");
            reset_dut();
            shift_mode = 1;
            data_in = 8'hFF;
            repeat(8) @(posedge clk);
            data_in = 8'h00;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Running Testcase 008: Alternating Pattern Left");
            reset_dut();
            shift_mode = 1;
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
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
        $dumpvars(0,clk, data_in, reset, shift_mode, data_out);
    end

endmodule
