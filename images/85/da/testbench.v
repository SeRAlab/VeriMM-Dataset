`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [2:0] factor;
    reg [17:0] start;
    reg [6:0] u;
    reg [6:0] v;
    wire [17:0] addr;
    wire [1:0] texelselect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .factor(factor),
        .start(start),
        .u(u),
        .v(v),
        .addr(addr),
        .texelselect(texelselect)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            factor = 0;
            start = 0;
            u = 0;
            v = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic mapping (u=4, v=0, factor=0, start=0)", test_num);
            reset_dut();
            u = 7'd4; v = 7'd0; factor = 3'd0; start = 18'd0; enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'h1, 2'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical coordinate (u=1, v=1, factor=0, start=0)", test_num);
            reset_dut();
            u = 7'd1; v = 7'd1; factor = 3'd0; start = 18'd0; enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'h0, 2'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stride factor (u=0, v=1, factor=2, start=0)", test_num);
            reset_dut();
            u = 7'd0; v = 7'd1; factor = 3'd2; start = 18'd0; enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'h1, 2'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Offset start address (u=0, v=1, factor=4, start=10)", test_num);
            reset_dut();
            u = 7'd0; v = 7'd1; factor = 3'd4; start = 18'd10; enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'd14, 2'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex mapping (u=7, v=3, factor=1, start=20)", test_num);
            reset_dut();
            u = 7'd7; v = 7'd3; factor = 3'd1; start = 18'd20; enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'd23, 2'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable signal low (should not update)", test_num);

            u = 7'd7; v = 7'd3; factor = 3'd1; start = 18'd20; enable = 1'b1;
            @(posedge clk);
            #1;

            u = 7'd0; v = 7'd0; factor = 3'd0; start = 18'd0; enable = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'd23, 2'h1);
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
        input [17:0] expected_addr;
        input [1:0] expected_texelselect;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_texelselect === (expected_texelselect ^ texelselect ^ expected_texelselect)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, texelselect=%h",
                         addr, texelselect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, texelselect=%h",
                         expected_addr, expected_texelselect);
                $display("  Got:      addr=%h, texelselect=%h",
                         addr, texelselect);
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
        $dumpvars(0,clk, enable, factor, start, u, v, addr, texelselect);
    end

endmodule
