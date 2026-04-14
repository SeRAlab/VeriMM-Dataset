`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addr_a;
    reg [13:0] addr_b;
    reg clk;
    reg [35:0] data_a;
    reg [35:0] data_b;
    reg re_a;
    reg re_b;
    reg rst_a;
    reg rst_b;
    reg we_a;
    reg we_b;
    wire [35:0] q_a;
    wire [35:0] q_b;

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
        .data_b(data_b),
        .re_a(re_a),
        .re_b(re_b),
        .rst_a(rst_a),
        .rst_b(rst_b),
        .we_a(we_a),
        .we_b(we_b),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_a = 1;
        rst_b = 1;
        addr_a = 0;
        addr_b = 0;
        data_a = 0;
        data_b = 0;
        we_a = 0;
        we_b = 0;
        re_a = 0;
        re_b = 0;
        @(posedge clk);
        #1;
        rst_a = 0;
        rst_b = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Port A Write then Read");


        addr_a = 14'h0123;
        data_a = 36'h5A5A5A5A5;
        we_a = 1;
        @(posedge clk);
        #1;
        we_a = 0;


        re_a = 1;
        addr_a = 14'h0123;
        @(posedge clk);
        #1;

        #1;


        check_outputs(36'h5A5A5A5A5, 36'h000000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Port B Write then Read");


        addr_b = 14'h3FFF;
        data_b = 36'hFFFFFFFFF;
        we_b = 1;
        @(posedge clk);
        #1;
        we_b = 0;


        re_b = 1;
        addr_b = 14'h3FFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(36'h000000000, 36'hFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Simultaneous Writes");


        addr_a = 14'h0001; data_a = 36'h111111111; we_a = 1;
        addr_b = 14'h0002; data_b = 36'h222222222; we_b = 1;
        @(posedge clk);
        #1;
        we_a = 0; we_b = 0;


        re_a = 1; addr_a = 14'h0001;
        re_b = 1; addr_b = 14'h0002;
        @(posedge clk);
        #1;

        #1;


        check_outputs(36'h111111111, 36'h222222222);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Port A Write, then Port B Read same address");


        addr_a = 14'h0ABC; data_a = 36'hCAFEBABE5; we_a = 1;
        @(posedge clk);
        #1;
        we_a = 0;


        re_b = 1; addr_b = 14'h0ABC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(36'h000000000, 36'hCAFEBABE5);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Output Register Reset");


        addr_a = 14'h0005; data_a = 36'hD0D0D0D0D; we_a = 1;
        @(posedge clk); #1; we_a = 0;

        re_a = 1; addr_a = 14'h0005;
        @(posedge clk); #1;


        rst_a = 1;
        @(posedge clk);
        #1;
        rst_a = 0;


        #1;



        check_outputs(36'h000000000, 36'h000000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Boundary Address 0");

        addr_a = 14'h0000; data_a = 36'h123456789; we_a = 1;
        addr_b = 14'h0000; data_b = 36'h123456789; we_b = 1;
        @(posedge clk); #1;
        we_a = 0; we_b = 0;

        re_a = 1; addr_a = 14'h0000;
        re_b = 1; addr_b = 14'h0000;
        @(posedge clk); #1;

        #1;


        check_outputs(36'h123456789, 36'h123456789);
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
        input [35:0] expected_q_a;
        input [35:0] expected_q_b;
        begin
            if (expected_q_a === (expected_q_a ^ q_a ^ expected_q_a) &&
                expected_q_b === (expected_q_b ^ q_b ^ expected_q_b)) begin
                $display("PASS");
                $display("  Outputs: q_a=%h, q_b=%h",
                         q_a, q_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_a=%h, q_b=%h",
                         expected_q_a, expected_q_b);
                $display("  Got:      q_a=%h, q_b=%h",
                         q_a, q_b);
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
        $dumpvars(0,addr_a, addr_b, clk, data_a, data_b, re_a, re_b, rst_a, rst_b, we_a, we_b, q_a, q_b);
    end

endmodule
