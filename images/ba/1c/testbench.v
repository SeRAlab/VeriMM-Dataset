`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg new_data_rdy;
    wire [27:0] dout;
    wire output_data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .new_data_rdy(new_data_rdy),
        .dout(dout),
        .output_data_ready(output_data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting/Clearing FIR pipeline...");
            new_data_rdy = 1'b1;
            din = 16'd0;
            repeat(10) @(posedge clk);
            new_data_rdy = 1'b0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Zero Input");
            din = 16'd0;
            new_data_rdy = 1'b1;
            repeat(10) @(posedge clk);
            new_data_rdy = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(28'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Constant Input (10)");
            repeat(15) begin
                @(posedge clk);
                din = 16'd10;
                new_data_rdy = 1'b1;
            end
            @(posedge clk);
            new_data_rdy = 1'b0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(28'd70, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Constant High Input (1000)");
            repeat(15) begin
                @(posedge clk);
                din = 16'd1000;
                new_data_rdy = 1'b1;
            end
            @(posedge clk);
            new_data_rdy = 1'b0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(28'd7000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Pulse Clean-out");
            @(posedge clk);
            din = 16'd100;
            new_data_rdy = 1'b1;
            @(posedge clk);
            din = 16'd0;
            repeat(10) @(posedge clk);
            new_data_rdy = 1'b0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(28'd0, 1'b1);
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
        input [27:0] expected_dout;
        input expected_output_data_ready;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_output_data_ready === (expected_output_data_ready ^ output_data_ready ^ expected_output_data_ready)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, output_data_ready=%b",
                         dout, output_data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, output_data_ready=%b",
                         expected_dout, expected_output_data_ready);
                $display("  Got:      dout=%h, output_data_ready=%b",
                         dout, output_data_ready);
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
        $dumpvars(0,clk, din, new_data_rdy, dout, output_data_ready);
    end

endmodule
