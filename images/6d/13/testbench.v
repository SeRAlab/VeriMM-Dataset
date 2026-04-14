`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] in_channel;
    reg [7:0] in_data;
    reg in_endofpacket;
    reg in_startofpacket;
    reg in_valid;
    reg out_ready;
    reg reset_n;
    wire in_ready;
    wire [7:0] out_data;
    wire out_endofpacket;
    wire out_startofpacket;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_channel(in_channel),
        .in_data(in_data),
        .in_endofpacket(in_endofpacket),
        .in_startofpacket(in_startofpacket),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .reset_n(reset_n),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_endofpacket(out_endofpacket),
        .out_startofpacket(out_startofpacket),
        .out_valid(out_valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: System Reset", test_num);
        reset_n = 0;
        in_valid = 1;
        in_data = 8'hFF;
        in_channel = 8'h02;
        out_ready = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 8'h00, 0, 0, 0);
        reset_n = 1;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Valid Channel Transmission (CH 0)", test_num);
        reset_n = 0; #10; reset_n = 1;
        @(posedge clk);
        in_valid = 1;
        in_data = 8'hA1;
        in_channel = 8'h00;
        in_startofpacket = 1;
        in_endofpacket = 0;
        out_ready = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1, 8'hA1, 0, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Boundary Valid Channel (CH 5)", test_num);
        reset_n = 0; #10; reset_n = 1;
        @(posedge clk);
        in_valid = 1;
        in_data = 8'hB2;
        in_channel = 8'h05;
        in_startofpacket = 0;
        in_endofpacket = 1;
        out_ready = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1, 8'hB2, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Channel Violation Suppression (CH 6)", test_num);
        reset_n = 0; #10; reset_n = 1;
        @(posedge clk);
        in_valid = 1;
        in_data = 8'hC3;
        in_channel = 8'h06;
        in_startofpacket = 1;
        in_endofpacket = 0;
        out_ready = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1, 8'h00, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Backpressure Handling (out_ready=0)", test_num);
        reset_n = 0; #10; reset_n = 1;
        @(posedge clk);
        in_valid = 1;
        in_data = 8'hD4;
        in_channel = 8'h01;
        out_ready = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(0, 8'h00, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Idle State (in_valid=0)", test_num);
        reset_n = 0; #10; reset_n = 1;
        @(posedge clk);
        in_valid = 0;
        in_data = 8'hE5;
        in_channel = 8'h01;
        out_ready = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1, 8'h00, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Max Channel Suppression (CH 255)", test_num);
        reset_n = 0; #10; reset_n = 1;
        @(posedge clk);
        in_valid = 1;
        in_data = 8'hF6;
        in_channel = 8'hFF;
        out_ready = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1, 8'h00, 0, 0, 0);
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
        input expected_in_ready;
        input [7:0] expected_out_data;
        input expected_out_endofpacket;
        input expected_out_startofpacket;
        input expected_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_endofpacket === (expected_out_endofpacket ^ out_endofpacket ^ expected_out_endofpacket) &&
                expected_out_startofpacket === (expected_out_startofpacket ^ out_startofpacket ^ expected_out_startofpacket) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_data=%h, out_endofpacket=%b, out_startofpacket=%b, out_valid=%b",
                         in_ready, out_data, out_endofpacket, out_startofpacket, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_data=%h, out_endofpacket=%b, out_startofpacket=%b, out_valid=%b",
                         expected_in_ready, expected_out_data, expected_out_endofpacket, expected_out_startofpacket, expected_out_valid);
                $display("  Got:      in_ready=%b, out_data=%h, out_endofpacket=%b, out_startofpacket=%b, out_valid=%b",
                         in_ready, out_data, out_endofpacket, out_startofpacket, out_valid);
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
