`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg [1:0] SW;
    reg [9:0] xAxis;
    reg [9:0] yAxis;
    reg [9:0] zAxis;
    wire [9:0] DOUT;
    wire [2:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .SW(SW),
        .xAxis(xAxis),
        .yAxis(yAxis),
        .zAxis(zAxis),
        .DOUT(DOUT),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            SW = 2'b00;
            xAxis = 10'd0;
            yAxis = 10'd0;
            zAxis = 10'd0;
            repeat(2) @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("testcase001: Selecting xAxis...");
            reset_dut();
            xAxis = 10'h123;
            yAxis = 10'h000;
            zAxis = 10'h000;
            SW = 2'b00;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h123, 3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("testcase002: Selecting yAxis...");
            reset_dut();
            xAxis = 10'h000;
            yAxis = 10'h246;
            zAxis = 10'h000;
            SW = 2'b01;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h246, 3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("testcase003: Selecting zAxis...");
            reset_dut();
            xAxis = 10'h000;
            yAxis = 10'h000;
            zAxis = 10'h3FF;
            SW = 2'b10;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h3FF, 3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("testcase004: Selecting SW=11 (Idle)...");
            reset_dut();
            xAxis = 10'h111;
            yAxis = 10'h222;
            zAxis = 10'h333;
            SW = 2'b11;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h000, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("testcase005: Changing xAxis data while selected...");
            reset_dut();
            SW = 2'b00;
            xAxis = 10'h0AA;
            repeat(2) @(posedge CLK);
            xAxis = 10'h0BB;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h0BB, 3'b001);
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
        input [9:0] expected_DOUT;
        input [2:0] expected_LED;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, LED=%h",
                         DOUT, LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, LED=%h",
                         expected_DOUT, expected_LED);
                $display("  Got:      DOUT=%h, LED=%h",
                         DOUT, LED);
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
        $dumpvars(0,CLK, RST, SW, xAxis, yAxis, zAxis, DOUT, LED);
    end

endmodule
