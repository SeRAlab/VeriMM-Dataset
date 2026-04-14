`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg in_valid;
    reg reset_b;
    reg serial_in;
    wire [7:0] data_out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_valid(in_valid),
        .reset_b(reset_b),
        .serial_in(serial_in),
        .data_out(data_out),
        .out_valid(out_valid)
    );
    task testcase001;

    integer i;
    begin
        test_num = 1;
        $display("Testcase %0d: Shifting in 0xFF...", test_num);
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            serial_in = 1;
            in_valid = 1;
        end


        @(negedge clk);
        in_valid = 0;
        serial_in = 0;


        #1;



        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = 2;
        $display("Testcase %0d: Shifting in 0x00...", test_num);
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            serial_in = 0;
            in_valid = 1;
        end

        @(negedge clk);
        in_valid = 0;

        #1;


        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase003;

    reg [7:0] pattern;
    integer i;
    begin
        test_num = 3;
        pattern = 8'hA5;
        $display("Testcase %0d: Shifting in 0x%h...", test_num, pattern);
        reset_dut();

        for (i = 7; i >= 0; i = i - 1) begin
            @(negedge clk);
            serial_in = pattern[i];
            in_valid = 1;
        end

        @(negedge clk);
        in_valid = 0;

        #1;


        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing intermittent in_valid...", test_num);
        reset_dut();


        repeat(4) begin
            @(negedge clk);
            serial_in = 1; in_valid = 1;
        end


        repeat(3) begin
            @(negedge clk);
            serial_in = 0; in_valid = 0;
        end


        repeat(4) begin
            @(negedge clk);
            serial_in = 1; in_valid = 1;
        end

        @(negedge clk);
        in_valid = 0;


        #1;



        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verify no early out_valid...", test_num);
        reset_dut();


        repeat(7) begin
            @(negedge clk);
            serial_in = 1; in_valid = 1;
        end

        @(negedge clk);
        in_valid = 0;




        if (out_valid === 1'b0) begin
            $display("PASS: out_valid correctly stayed low at 7 bits.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: out_valid pulsed early at 7 bits.");
            fail_count = fail_count + 1;
        end
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
        input expected_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, out_valid=%b",
                         data_out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, out_valid=%b",
                         expected_data_out, expected_out_valid);
                $display("  Got:      data_out=%h, out_valid=%b",
                         data_out, out_valid);
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

endmodule
