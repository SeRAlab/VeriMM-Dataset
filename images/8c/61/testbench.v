`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_in_valid;
    reg reset;
    wire [7:0] data_out;
    wire data_out_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .reset(reset),
        .data_out(data_out),
        .data_out_ack(data_out_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            data_in_valid = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Data Transfer (0xAA)", test_num);
            reset_dut();
            data_in = 8'hAA;
            data_in_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data provided but Valid Low", test_num);
            reset_dut();
            data_in = 8'h55;
            data_in_valid = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Consecutive Data Transfers", test_num);
            reset_dut();

            data_in = 8'h11;
            data_in_valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'h22;
            data_in_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Transfer Boundary Value (0xFF)", test_num);
            reset_dut();
            data_in = 8'hFF;
            data_in_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Deassert Valid after transfer", test_num);
            reset_dut();

            data_in = 8'h33;
            data_in_valid = 1;
            @(posedge clk);
            #1;

            data_in_valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(data_out, 1'b0);
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
        input expected_data_out_ack;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_ack === (expected_data_out_ack ^ data_out_ack ^ expected_data_out_ack)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_ack=%b",
                         data_out, data_out_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_ack=%b",
                         expected_data_out, expected_data_out_ack);
                $display("  Got:      data_out=%h, data_out_ack=%b",
                         data_out, data_out_ack);
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
        $dumpvars(0,clk, data_in, data_in_valid, reset, data_out, data_out_ack);
    end

endmodule
