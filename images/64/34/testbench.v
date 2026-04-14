`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        A = 0;
        B = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0 * 0", test_num);
        reset_dut();
        A = 8'd0;
        B = 8'd0;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 1 * 1", test_num);
        reset_dut();
        A = 8'd1;
        B = 8'd1;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 255 * 1", test_num);
        reset_dut();
        A = 8'd255;
        B = 8'd1;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 1 * 255", test_num);
        reset_dut();
        A = 8'd1;
        B = 8'd255;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 255 * 255", test_num);
        reset_dut();
        A = 8'd255;
        B = 8'd255;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 123 * 45", test_num);
        reset_dut();
        A = 8'd123;
        B = 8'd45;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd5535);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 128 * 2", test_num);
        reset_dut();
        A = 8'd128;
        B = 8'd2;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0 * 255", test_num);
        reset_dut();
        A = 8'd0;
        B = 8'd255;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0xAA * 0x55", test_num);
        reset_dut();
        A = 8'hAA;
        B = 8'h55;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd14450);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 15 * 16", test_num);
        reset_dut();
        A = 8'd15;
        B = 8'd16;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd240);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, reset, P);
    end

endmodule
