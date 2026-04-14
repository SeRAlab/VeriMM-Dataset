`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset State Verification", test_num);
        reset_dut();
        @(posedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shifting eight 1s (0xFF)", test_num);
        reset_dut();
        for(i=0; i<8; i=i+1) begin
            data_in = 1;
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shifting pattern 0xAA (10101010)", test_num);
        reset_dut();
        pattern = 8'hAA;
        for(i=7; i>=0; i=i-1) begin
            data_in = pattern[i];
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shifting pattern 0x3C (00111100)", test_num);
        reset_dut();
        pattern = 8'h3C;
        for(i=7; i>=0; i=i-1) begin
            data_in = pattern[i];
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase005;

    integer i;
    reg [11:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow check (12 bits shifted)", test_num);
        reset_dut();
        pattern = 12'hF96;
        for(i=11; i>=0; i=i-1) begin
            data_in = pattern[i];
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'h96);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift 4 bits then Reset mid-way", test_num);
        reset_dut();

        for(i=0; i<4; i=i+1) begin
            data_in = 1;
            @(posedge clk);
            #1;
        end

        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        #1;

        check_outputs(8'h00);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
