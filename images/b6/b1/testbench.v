`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg reset;
    reg [4:0] shift_amount;
    wire [31:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .shift_amount(shift_amount),
        .shifted_data(shifted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        data = 0;
        shift_amount = 0;
        @(negedge clk);
        reset = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        reset = 0;
        data = 32'hFFFFFFFF;
        shift_amount = 5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        data = 32'h12345678;
        shift_amount = 5'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        data = 32'h00000001;
        shift_amount = 5'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        data = 32'h0000FFFF;
        shift_amount = 5'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00FFFF00);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        data = 32'h00000001;
        shift_amount = 5'd31;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        data = 32'hF0000000;
        shift_amount = 5'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        data = 32'hFFFFFFFF;
        shift_amount = 5'd16;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFF0000);
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
        input [31:0] expected_shifted_data;
        begin
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
        $dumpvars(0,clk, data, reset, shift_amount, shifted_data);
    end

endmodule
