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
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Immediate completion (X >= A)", test_num);
            reset_dut();
            Xinport = 32'h0000_000A;
            Yinport = 32'h0000_0014;
            Uinport = 32'h0000_001E;
            Aport   = 32'h0000_000A;
            DXport  = 32'h0000_0001;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(32'h0000_001E, 32'h0000_000A, 32'h0000_0014);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single step integration", test_num);
            reset_dut();
            Xinport = 32'd0;
            Yinport = 32'd5;
            Uinport = 32'd10;
            Aport   = 32'd1;
            DXport  = 32'd1;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(32'hffff_fffb, 32'd1, 32'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two-step integration", test_num);
            reset_dut();
            Xinport = 32'd0;
            Yinport = 32'd1;
            Uinport = 32'd2;
            Aport   = 32'd2;
            DXport  = 32'd1;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(32'hffff_fff9, 32'd2, 32'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DX=0 stability check", test_num);
            reset_dut();
            Xinport = 32'd5;
            Yinport = 32'd5;
            Uinport = 32'd5;
            Aport   = 32'd10;
            DXport  = 32'd0;

            repeat (10) @(posedge clk);


            #1;



            check_outputs(32'h0000_0005, 32'h0000_0005, 32'h0000_0005);
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
