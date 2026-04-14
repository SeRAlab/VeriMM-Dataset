`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Aport;
    reg [31:0] DXport;
    reg [31:0] Uinport;
    reg [31:0] Xinport;
    reg [31:0] Yinport;
    reg clk;
    reg reset;
    wire [31:0] Uoutport;
    wire [31:0] Xoutport;
    wire [31:0] Youtport;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Aport(Aport),
        .DXport(DXport),
        .Uinport(Uinport),
        .Xinport(Xinport),
        .Yinport(Yinport),
        .clk(clk),
        .reset(reset),
        .Uoutport(Uoutport),
        .Xoutport(Xoutport),
        .Youtport(Youtport)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Aport = 0;
            DXport = 0;
            Uinport = 0;
            Xinport = 0;
            Yinport = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            Xinport = 32'h0;
            Yinport = 32'h2;
            Uinport = 32'h1;
            DXport  = 32'h1;
            Aport   = 32'h2;


            repeat (100) @(posedge clk);

            $display("Test Case 001: Multi-step iteration (X=0 to 2)");
            #1;

            check_outputs(32'h00000001, 32'h00000002, 32'hFFFFFFFE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            Xinport = 32'h5;
            Yinport = 32'h2;
            Uinport = 32'h1;
            DXport  = 32'h1;
            Aport   = 32'h5;

            repeat (10) @(posedge clk);

            $display("Test Case 002: Immediate termination (X=5, A=5)");
            #1;

            check_outputs(32'h00000001, 32'h00000005, 32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            Xinport = 32'h0;
            Yinport = 32'h1;
            Uinport = 32'h1;
            DXport  = 32'h1;
            Aport   = 32'h1;

            repeat (50) @(posedge clk);

            $display("Test Case 003: Single iteration (X=0 to 1)");
            #1;

            check_outputs(32'hFFFFFFFE, 32'h00000001, 32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            Xinport = 32'h0;
            Yinport = 32'h0;
            Uinport = 32'd10;
            DXport  = 32'h1;
            Aport   = 32'h1;

            repeat (50) @(posedge clk);

            $display("Test Case 004: Zero starting Y (X=0 to 1)");
            #1;

            check_outputs(32'h0000000A, 32'h00000001, 32'h0000000A);
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
        input [31:0] expected_Uoutport;
        input [31:0] expected_Xoutport;
        input [31:0] expected_Youtport;
        begin
            if (expected_Uoutport === (expected_Uoutport ^ Uoutport ^ expected_Uoutport) &&
                expected_Xoutport === (expected_Xoutport ^ Xoutport ^ expected_Xoutport) &&
                expected_Youtport === (expected_Youtport ^ Youtport ^ expected_Youtport)) begin
                $display("PASS");
                $display("  Outputs: Uoutport=%h, Xoutport=%h, Youtport=%h",
                         Uoutport, Xoutport, Youtport);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Uoutport=%h, Xoutport=%h, Youtport=%h",
                         expected_Uoutport, expected_Xoutport, expected_Youtport);
                $display("  Got:      Uoutport=%h, Xoutport=%h, Youtport=%h",
                         Uoutport, Xoutport, Youtport);
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
        $dumpvars(0,Aport, DXport, Uinport, Xinport, Yinport, clk, reset, Uoutport, Xoutport, Youtport);
    end

endmodule
