`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [28:0] xin;
    reg [28:0] yin;
    reg [28:0] zin;
    wire [28:0] xout;
    wire [28:0] yout;
    wire [28:0] zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .xin(xin),
        .yin(yin),
        .zin(zin),
        .xout(xout),
        .yout(yout),
        .zout(zout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            xin = 29'd0;
            yin = 29'd0;
            zin = 29'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001: Basic Delay Check");
            reset_dut();
            xin = 29'h12345678;
            yin = 29'h0ABCDEF1;
            zin = 29'h1FFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(29'h12345678, 29'h0ABCDEF1, 29'h1FFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002: Edge Case (All 0s and 1s)");
            reset_dut();
            xin = 29'h00000000;
            yin = 29'h1FFFFFFF;
            zin = 29'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(29'h00000000, 29'h1FFFFFFF, 29'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003: Alternating Patterns");
            reset_dut();
            xin = 29'h15555555;
            yin = 29'h0AAAAAAA;
            zin = 29'h1FFFFFF0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(29'h15555555, 29'h0AAAAAAA, 29'h1FFFFFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004: Pipeline Continuity");
            reset_dut();


            xin = 29'h11111111;
            yin = 29'h11111111;
            zin = 29'h11111111;
            @(posedge clk);


            xin = 29'h1EEEEEEE;
            yin = 29'h1DDDDDDD;
            zin = 29'h1BBBBBBB;
            @(posedge clk);

            #1;

            #1;


            check_outputs(29'h1EEEEEEE, 29'h1DDDDDDD, 29'h1BBBBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase005: Random Values");
            reset_dut();
            xin = 29'h0CAFEBAB;
            yin = 29'h1DEADBEE;
            zin = 29'h0BADC0DE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(29'h0CAFEBAB, 29'h1DEADBEE, 29'h0BADC0DE);
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
        input [28:0] expected_xout;
        input [28:0] expected_yout;
        input [28:0] expected_zout;
        begin
            if (expected_xout === (expected_xout ^ xout ^ expected_xout) &&
                expected_yout === (expected_yout ^ yout ^ expected_yout) &&
                expected_zout === (expected_zout ^ zout ^ expected_zout)) begin
                $display("PASS");
                $display("  Outputs: xout=%h, yout=%h, zout=%h",
                         xout, yout, zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xout=%h, yout=%h, zout=%h",
                         expected_xout, expected_yout, expected_zout);
                $display("  Got:      xout=%h, yout=%h, zout=%h",
                         xout, yout, zout);
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
        $dumpvars(0,clk, xin, yin, zin, xout, yout, zout);
    end

endmodule
