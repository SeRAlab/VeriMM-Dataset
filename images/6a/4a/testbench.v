`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [31:0] data_in;
    reg ena;
    reg load;
    reg [3:0] reg_data_in;
    reg [4:0] shift_amount;
    wire [31:0] data_out;
    wire [3:0] q;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data_in(data_in),
        .ena(ena),
        .load(load),
        .reg_data_in(reg_data_in),
        .shift_amount(shift_amount),
        .data_out(data_out),
        .q(q),
        .zero_flag(zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            areset = 1;
            load = 0;
            ena = 0;
            data_in = 0;
            reg_data_in = 0;
            shift_amount = 0;
            @(posedge clk);
            #2 areset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(32'h0, 4'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 32'hDEADBEEF;
            shift_amount = 5'd0;
            @(posedge clk);
            #1;

            check_outputs(32'hDEADBEEF, 4'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            reg_data_in = 4'b1011;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'h0, 4'b1011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            reg_data_in = 4'b1000;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 1;
            @(posedge clk);
            #1;

            check_outputs(32'h0, 4'b0100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 32'h00000001;
            shift_amount = 5'd1;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 4'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data_in = 32'hF0F0F0F0;
            shift_amount = 5'd4;
            reg_data_in = 4'b0101;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            #1;



            check_outputs(32'h0F0F0F0F, 4'b0101, 1'b0);
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
        input [31:0] expected_data_out;
        input [3:0] expected_q;
        input expected_zero_flag;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, q=%h, zero_flag=%b",
                         data_out, q, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, q=%h, zero_flag=%b",
                         expected_data_out, expected_q, expected_zero_flag);
                $display("  Got:      data_out=%h, q=%h, zero_flag=%b",
                         data_out, q, zero_flag);
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
        $dumpvars(0,areset, clk, data_in, ena, load, reg_data_in, shift_amount, data_out, q, zero_flag);
    end

endmodule
