`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] aport;
    reg clk;
    reg [31:0] dxport;
    reg reset;
    wire [31:0] uport;
    wire [31:0] xport;
    wire [31:0] yport;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aport(aport),
        .clk(clk),
        .dxport(dxport),
        .reset(reset),
        .uport(uport),
        .xport(xport),
        .yport(yport)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            aport = 32'h0;
            dxport = 32'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000002, 32'h00000000, 32'h00000003);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Step Evolution (dx=1, a=10)", test_num);
            reset_dut();
            aport = 32'd10;
            dxport = 32'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hfffffff9, 32'h00000001, 32'h00000005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Two Step Evolution (dx=1, a=10)", test_num);
            reset_dut();
            aport = 32'd10;
            dxport = 32'd1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(32'hffffffff, 32'h00000002, 32'hfffffffffe);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Termination Check (x >= a)", test_num);
            reset_dut();
            aport = 32'd1;
            dxport = 32'd1;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(32'hfffffff9, 32'h00000001, 32'h00000005);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Step size (dx=2, a=4)", test_num);
            reset_dut();
            aport = 32'd4;
            dxport = 32'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hfffffff0, 32'h00000002, 32'h00000007);
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
        input [31:0] expected_uport;
        input [31:0] expected_xport;
        input [31:0] expected_yport;
        begin
            if (expected_uport === (expected_uport ^ uport ^ expected_uport) &&
                expected_xport === (expected_xport ^ xport ^ expected_xport) &&
                expected_yport === (expected_yport ^ yport ^ expected_yport)) begin
                $display("PASS");
                $display("  Outputs: uport=%h, xport=%h, yport=%h",
                         uport, xport, yport);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: uport=%h, xport=%h, yport=%h",
                         expected_uport, expected_xport, expected_yport);
                $display("  Got:      uport=%h, xport=%h, yport=%h",
                         uport, xport, yport);
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
        $dumpvars(0,aport, clk, dxport, reset, uport, xport, yport);
    end

endmodule
