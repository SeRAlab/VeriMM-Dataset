`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_a;
    reg [31:0] addr_b;
    reg clk;
    reg [31:0] data_a;
    reg [31:0] data_b_in;
    reg [31:0] data_b_we;
    reg rst;
    wire [31:0] data_b;
    wire strobe_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk(clk),
        .data_a(data_a),
        .data_b_in(data_b_in),
        .data_b_we(data_b_we),
        .rst(rst),
        .data_b(data_b),
        .strobe_b(strobe_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_a = 0;
            addr_b = 0;
            data_a = 0;
            data_b_in = 0;
            data_b_we = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Counting...");
            reset_dut();


            repeat (10) @(posedge clk);


            #1;
            addr_b = 32'd65542;
            #1;
            #1;

            check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reset mid-count...");
            reset_dut();
            repeat (20) @(posedge clk);


            #1; addr_b = 32'd65542; #1;
            if (data_b !== 32'd20) $display("Intermediate count wrong");


            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Wrong Address Access...");
            reset_dut();
            repeat (15) @(posedge clk);

            #1;
            addr_b = 32'd100;
            #1;

            #1;


            check_outputs(data_b, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Logging check with WE...");
            reset_dut();
            repeat (7) @(posedge clk);

            #1;
            addr_b = 32'd65542;
            data_b_we = 32'hFFFFFFFF;
            #1;

            #1;


            check_outputs(32'd7, 1'b1);
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
        input [31:0] expected_data_b;
        input expected_strobe_b;
        begin
            if (expected_data_b === (expected_data_b ^ data_b ^ expected_data_b) &&
                expected_strobe_b === (expected_strobe_b ^ strobe_b ^ expected_strobe_b)) begin
                $display("PASS");
                $display("  Outputs: data_b=%h, strobe_b=%b",
                         data_b, strobe_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_b=%h, strobe_b=%b",
                         expected_data_b, expected_strobe_b);
                $display("  Got:      data_b=%h, strobe_b=%b",
                         data_b, strobe_b);
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
        $dumpvars(0,addr_a, addr_b, clk, data_a, data_b_in, data_b_we, rst, data_b, strobe_b);
    end

endmodule
