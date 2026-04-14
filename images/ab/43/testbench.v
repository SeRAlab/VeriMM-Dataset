`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] n1;
    reg [31:0] n2;
    reg [31:0] round_key;
    reg [511:0] sbox;
    wire [31:0] out1;
    wire [31:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .n1(n1),
        .n2(n2),
        .round_key(round_key),
        .sbox(sbox),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            n1 = 0;
            n2 = 0;
            round_key = 0;
            sbox = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            n1 = 32'h0;
            n2 = 32'h12345678;
            round_key = 32'h0;
            sbox = 512'h0;

            @(posedge clk);
            #2;
            $display("Test Case 001: Zero Inputs, Zero S-box");
            #1;

            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            n1 = 32'hAAAAAAAA;
            n2 = 32'h55555555;
            round_key = 32'h00000000;
            sbox = {8{64'hfedcba9876543210}};

            @(posedge clk);
            #2;


            $display("Test Case 002: Identity S-box, out2 result 0");
            #1;

            check_outputs(32'h55555555, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            n1 = 32'h01234567;
            n2 = 32'h0;
            round_key = 32'h0;
            sbox = {8{64'h0123456789abcdef}};

            @(posedge clk);
            #2;




            $display("Test Case 003: Inverting S-box, out2 result FFFFFFFF");
            #1;

            check_outputs(32'h0, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            n1 = 32'hFFFFFFFF;
            n2 = 32'h88888888;
            round_key = 32'h00000001;
            sbox = {8{64'hfedcba9876543210}};

            @(posedge clk);
            #2;



            $display("Test Case 004: Addition overflow/masking");
            #1;

            check_outputs(32'h88888888, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            n1 = 32'h10101010;
            n2 = 32'h20202020;
            round_key = 32'h01010101;
            sbox = {8{64'hfedcba9876543210}};

            @(posedge clk);
            #2;



            $display("Test Case 005: Non-zero Round Key");
            #1;

            check_outputs(32'h20202020, 32'h01010101);
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
        $dumpvars(0,clk, n1, n2, round_key, sbox, out1, out2);
    end

endmodule
