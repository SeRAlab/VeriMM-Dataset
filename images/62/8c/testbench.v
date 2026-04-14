`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] io_in_0_bits;
    reg [4:0] io_in_0_tag;
    reg io_in_0_valid;
    reg io_out_ready;
    reg reset;
    wire io_chosen;
    wire io_in_0_ready;
    wire [31:0] io_out_bits;
    wire [4:0] io_out_tag;
    wire io_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_in_0_bits(io_in_0_bits),
        .io_in_0_tag(io_in_0_tag),
        .io_in_0_valid(io_in_0_valid),
        .io_out_ready(io_out_ready),
        .reset(reset),
        .io_chosen(io_chosen),
        .io_in_0_ready(io_in_0_ready),
        .io_out_bits(io_out_bits),
        .io_out_tag(io_out_tag),
        .io_out_valid(io_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        io_in_0_bits = 32'h0;
        io_in_0_tag = 5'h0;
        io_in_0_valid = 1'b0;
        io_out_ready = 1'b0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Data Forwarding", test_num);
        reset_dut();

        io_in_0_bits = 32'hDEADBEEF;
        io_in_0_tag = 5'h1A;
        io_in_0_valid = 1'b1;
        io_out_ready = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 32'hDEADBEEF, 5'h1A, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Backpressure (Ready Low)", test_num);
        reset_dut();

        io_in_0_bits = 32'hCAFEBABE;
        io_in_0_tag = 5'h07;
        io_in_0_valid = 1'b1;
        io_out_ready = 1'b0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 32'hCAFEBABE, 5'h07, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Idle State (Valid Low)", test_num);
        reset_dut();

        io_in_0_bits = 32'h12345678;
        io_in_0_tag = 5'h00;
        io_in_0_valid = 1'b0;
        io_out_ready = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 32'h12345678, 5'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Tag Bit Boundary", test_num);
        reset_dut();

        io_in_0_bits = 32'hFFFFFFFF;
        io_in_0_tag = 5'h1F;
        io_in_0_valid = 1'b1;
        io_out_ready = 1'b1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 32'hFFFFFFFF, 5'h1F, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Full Stall (Neither Valid nor Ready)", test_num);
        reset_dut();

        io_in_0_bits = 32'h0000AAAA;
        io_in_0_tag = 5'h10;
        io_in_0_valid = 1'b0;
        io_out_ready = 1'b0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 32'h0000AAAA, 5'h10, 1'b0);
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
        input expected_io_chosen;
        input expected_io_in_0_ready;
        input [31:0] expected_io_out_bits;
        input [4:0] expected_io_out_tag;
        input expected_io_out_valid;
        begin
            if (expected_io_chosen === (expected_io_chosen ^ io_chosen ^ expected_io_chosen) &&
                expected_io_in_0_ready === (expected_io_in_0_ready ^ io_in_0_ready ^ expected_io_in_0_ready) &&
                expected_io_out_bits === (expected_io_out_bits ^ io_out_bits ^ expected_io_out_bits) &&
                expected_io_out_tag === (expected_io_out_tag ^ io_out_tag ^ expected_io_out_tag) &&
                expected_io_out_valid === (expected_io_out_valid ^ io_out_valid ^ expected_io_out_valid)) begin
                $display("PASS");
                $display("  Outputs: io_chosen=%b, io_in_0_ready=%b, io_out_bits=%h, io_out_tag=%h, io_out_valid=%b",
                         io_chosen, io_in_0_ready, io_out_bits, io_out_tag, io_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_chosen=%b, io_in_0_ready=%b, io_out_bits=%h, io_out_tag=%h, io_out_valid=%b",
                         expected_io_chosen, expected_io_in_0_ready, expected_io_out_bits, expected_io_out_tag, expected_io_out_valid);
                $display("  Got:      io_chosen=%b, io_in_0_ready=%b, io_out_bits=%h, io_out_tag=%h, io_out_valid=%b",
                         io_chosen, io_in_0_ready, io_out_bits, io_out_tag, io_out_valid);
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
        $dumpvars(0,clk, io_in_0_bits, io_in_0_tag, io_in_0_valid, io_out_ready, reset, io_chosen, io_in_0_ready, io_out_bits, io_out_tag, io_out_valid);
    end

endmodule
