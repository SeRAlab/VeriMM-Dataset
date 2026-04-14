`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [7:0] Di;
    reg [3:0] button_data;
    reg clock;
    reg cs;
    reg int_ack;
    reg rd_n;
    reg reset;
    reg wr_n;
    wire [7:0] Do;
    wire [1:0] button_sel;
    wire int_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Di(Di),
        .button_data(button_data),
        .clock(clock),
        .cs(cs),
        .int_ack(int_ack),
        .rd_n(rd_n),
        .reset(reset),
        .wr_n(wr_n),
        .Do(Do),
        .button_sel(button_sel),
        .int_req(int_req)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        A = 16'h0000;
        Di = 8'h00;
        button_data = 4'hF;
        cs = 0;
        int_ack = 0;
        rd_n = 1;
        wr_n = 1;
        repeat(2) @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case 001: Reset State");

        #1;


        check_outputs(8'hzz, 2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case 002: Write to 0xFF00");

        @(posedge clock);
        #1;
        A = 16'hFF00;
        Di = 8'h20;
        cs = 1;
        wr_n = 0;

        @(posedge clock);
        #1;
        wr_n = 1;
        cs = 0;


        #1;



        check_outputs(8'hzz, 2'b10, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case 003: Read from 0xFF00");


        @(posedge clock);
        #1;
        A = 16'hFF00;
        Di = 8'h10;
        cs = 1;
        wr_n = 0;
        @(posedge clock);
        #1;
        wr_n = 1;


        button_data = 4'hA;
        rd_n = 0;



        @(posedge clock);
        #1;
        #1;

        check_outputs(8'hDA, 2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case 004: Interrupt Acknowledgment");


        @(posedge clock);
        #1;
        A = 16'hFF00;
        Di = 8'h30;
        cs = 1;
        wr_n = 0;
        @(posedge clock);
        #1;
        wr_n = 1;
        cs = 0;


        @(posedge clock);
        #1;
        int_ack = 1;
        @(posedge clock);
        #1;
        int_ack = 0;


        #1;



        check_outputs(8'hzz, 2'b11, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case 005: Write to Incorrect Address");

        @(posedge clock);
        #1;
        A = 16'hFE00;
        Di = 8'h20;
        cs = 1;
        wr_n = 0;
        @(posedge clock);
        #1;
        wr_n = 1;


        #1;



        check_outputs(8'hzz, 2'b00, 1'b0);
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
        input [7:0] expected_Do;
        input [1:0] expected_button_sel;
        input expected_int_req;
        begin
            if (expected_Do === (expected_Do ^ Do ^ expected_Do) &&
                expected_button_sel === (expected_button_sel ^ button_sel ^ expected_button_sel) &&
                expected_int_req === (expected_int_req ^ int_req ^ expected_int_req)) begin
                $display("PASS");
                $display("  Outputs: Do=%h, button_sel=%h, int_req=%b",
                         Do, button_sel, int_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Do=%h, button_sel=%h, int_req=%b",
                         expected_Do, expected_button_sel, expected_int_req);
                $display("  Got:      Do=%h, button_sel=%h, int_req=%b",
                         Do, button_sel, int_req);
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
        $dumpvars(0,A, Di, button_data, clock, cs, int_ack, rd_n, reset, wr_n, Do, button_sel, int_req);
    end

endmodule
