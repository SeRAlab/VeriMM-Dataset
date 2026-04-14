`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a_addr;
    reg [3:0] a_din;
    reg a_wen;
    reg [3:0] b_addr;
    reg [3:0] b_din;
    reg b_wen;
    reg clk;
    wire [3:0] a_dout;
    wire [3:0] b_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_addr(a_addr),
        .a_din(a_din),
        .a_wen(a_wen),
        .b_addr(b_addr),
        .b_din(b_din),
        .b_wen(b_wen),
        .clk(clk),
        .a_dout(a_dout),
        .b_dout(b_dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a_addr = 0;
            a_din = 0;
            a_wen = 0;
            b_addr = 0;
            b_din = 0;
            b_wen = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Port A Write/Read...");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            a_addr = 4'h1; a_din = 4'hA; a_wen = 1;
            @(posedge clk);
            a_wen = 0;


            a_addr = 4'h1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Port B Write/Read...");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            b_addr = 4'hF; b_din = 4'h5; b_wen = 1;
            @(posedge clk);
            b_wen = 0;


            b_addr = 4'hF;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simultaneous Writes...");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            a_addr = 4'h2; a_din = 4'h2; a_wen = 1;
            b_addr = 4'h3; b_din = 4'h3; b_wen = 1;
            @(posedge clk);
            a_wen = 0; b_wen = 0;


            a_addr = 4'h2;
            b_addr = 4'h3;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h2, 4'h3);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Cross-Port Verification...");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            a_addr = 4'h5; a_din = 4'hE; a_wen = 1;
            @(posedge clk);
            a_wen = 0;


            b_addr = 4'h5;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'hE);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Write Enable Check...");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            a_addr = 4'h8; a_din = 4'h7; a_wen = 1;
            @(posedge clk);


            a_addr = 4'h8; a_din = 4'h0; a_wen = 0;
            @(posedge clk);


            a_addr = 4'h8;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7, 4'h0);
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
        input [3:0] expected_a_dout;
        input [3:0] expected_b_dout;
        begin
            if (expected_a_dout === (expected_a_dout ^ a_dout ^ expected_a_dout) &&
                expected_b_dout === (expected_b_dout ^ b_dout ^ expected_b_dout)) begin
                $display("PASS");
                $display("  Outputs: a_dout=%h, b_dout=%h",
                         a_dout, b_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_dout=%h, b_dout=%h",
                         expected_a_dout, expected_b_dout);
                $display("  Got:      a_dout=%h, b_dout=%h",
                         a_dout, b_dout);
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
        $dumpvars(0,a_addr, a_din, a_wen, b_addr, b_din, b_wen, clk, a_dout, b_dout);
    end

endmodule
