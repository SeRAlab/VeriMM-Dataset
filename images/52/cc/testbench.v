`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr1;
    reg [1:0] addr2;
    reg [1:0] addr3;
    reg [1:0] addr4;
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg [7:0] data_in3;
    reg [7:0] data_in4;
    reg we1;
    reg we2;
    reg we3;
    reg we4;
    wire [7:0] data_out1;
    wire [7:0] data_out2;
    wire [7:0] data_out3;
    wire [7:0] data_out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .addr3(addr3),
        .addr4(addr4),
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .data_in4(data_in4),
        .we1(we1),
        .we2(we2),
        .we3(we3),
        .we4(we4),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out3(data_out3),
        .data_out4(data_out4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin

        we1 = 0; we2 = 0; we3 = 0; we4 = 0;
        addr1 = 0; addr2 = 0; addr3 = 0; addr4 = 0;
        data_in1 = 0; data_in2 = 0; data_in3 = 0; data_in4 = 0;


        @(posedge clk);
        #1;


        we1 = 1; we2 = 1; we3 = 1; we4 = 1;
        addr1 = 2'd0; addr2 = 2'd1; addr3 = 2'd2; addr4 = 2'd3;
        data_in1 = 8'h00; data_in2 = 8'h00; data_in3 = 8'h00; data_in4 = 8'h00;
        @(posedge clk);
        #1;
        we1 = 0; we2 = 0; we3 = 0; we4 = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Parallel Write to all 4 registers");
        reset_dut();


        we1 = 1; we2 = 1; we3 = 1; we4 = 1;
        addr1 = 2'd0; addr2 = 2'd1; addr3 = 2'd2; addr4 = 2'd3;
        data_in1 = 8'hA1; data_in2 = 8'hB2; data_in3 = 8'hC3; data_in4 = 8'hD4;

        @(posedge clk);
        #1;


        we1 = 0; we2 = 0; we3 = 0; we4 = 0;
        addr1 = 2'd0; addr2 = 2'd1; addr3 = 2'd2; addr4 = 2'd3;
        #2;

        #1;


        check_outputs(8'hA1, 8'hB2, 8'hC3, 8'hD4);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Verify Write Enable signal (WE=0)");
        reset_dut();


        we1 = 1; addr1 = 2'd0; data_in1 = 8'hFF;
        @(posedge clk);
        #1;


        we1 = 0; addr1 = 2'd0; data_in1 = 8'hEE;
        @(posedge clk);
        #1;


        addr1 = 2'd0; addr2 = 2'd1; addr3 = 2'd2; addr4 = 2'd3;
        #2;
        #1;

        check_outputs(8'hFF, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Simultaneous Read from the same register");
        reset_dut();


        we1 = 1; addr1 = 2'd2; data_in1 = 8'h55;
        @(posedge clk);
        #1;


        we1 = 0;
        addr1 = 2'd2; addr2 = 2'd2; addr3 = 2'd2; addr4 = 2'd2;
        #2;

        #1;


        check_outputs(8'h55, 8'h55, 8'h55, 8'h55);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Sequential writes using Port 1");
        reset_dut();


        we1 = 1; addr1 = 2'd0; data_in1 = 8'h10;
        @(posedge clk); #1;

        we1 = 1; addr1 = 2'd1; data_in1 = 8'h21;
        @(posedge clk); #1;

        we1 = 1; addr1 = 2'd2; data_in1 = 8'h32;
        @(posedge clk); #1;

        we1 = 1; addr1 = 2'd3; data_in1 = 8'h43;
        @(posedge clk); #1;


        we1 = 0;
        addr1 = 2'd0; addr2 = 2'd1; addr3 = 2'd2; addr4 = 2'd3;
        #2;

        #1;


        check_outputs(8'h10, 8'h21, 8'h32, 8'h43);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Data Persistence Check");
        reset_dut();


        we2 = 1; addr2 = 2'd1; data_in2 = 8'h99;
        @(posedge clk);
        #1;


        we2 = 0; addr2 = 0; data_in2 = 0;
        repeat(3) @(posedge clk);
        #1;


        addr1 = 2'd1; addr2 = 2'd1; addr3 = 2'd1; addr4 = 2'd1;
        #2;

        #1;


        check_outputs(8'h99, 8'h99, 8'h99, 8'h99);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        input [7:0] expected_data_out3;
        input [7:0] expected_data_out4;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_data_out3 === (expected_data_out3 ^ data_out3 ^ expected_data_out3) &&
                expected_data_out4 === (expected_data_out4 ^ data_out4 ^ expected_data_out4)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h",
                         data_out1, data_out2, data_out3, data_out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h",
                         expected_data_out1, expected_data_out2, expected_data_out3, expected_data_out4);
                $display("  Got:      data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h",
                         data_out1, data_out2, data_out3, data_out4);
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
        $dumpvars(0,addr1, addr2, addr3, addr4, clk, data_in1, data_in2, data_in3, data_in4, we1, we2, we3, we4, data_out1, data_out2, data_out3, data_out4);
    end

endmodule
