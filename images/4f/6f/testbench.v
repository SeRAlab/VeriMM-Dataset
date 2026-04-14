`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] r1Addr;
    reg [4:0] r2Addr;
    reg rst_n;
    reg [4:0] wAddr;
    reg [31:0] wDin;
    reg wEna;
    wire [31:0] r1Dout;
    wire [31:0] r2Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r1Addr(r1Addr),
        .r2Addr(r2Addr),
        .rst_n(rst_n),
        .wAddr(wAddr),
        .wDin(wDin),
        .wEna(wEna),
        .r1Dout(r1Dout),
        .r2Dout(r2Dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            wEna = 0;
            wAddr = 0;
            wDin = 0;
            r1Addr = 0;
            r2Addr = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            r1Addr = 5'd10;
            r2Addr = 5'd20;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Readback", test_num);
            reset_dut();

            @(posedge clk);
            wEna = 1;
            wAddr = 5'd5;
            wDin = 32'hABCDEFF0;
            @(posedge clk);
            wEna = 0;

            r1Addr = 5'd5;
            r2Addr = 5'd0;
            #2;
            #1;

            check_outputs(32'hABCDEFF0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Dual Read", test_num);
            reset_dut();


            @(posedge clk);
            wEna = 1; wAddr = 5'd2; wDin = 32'h11112222;
            @(posedge clk);

            wAddr = 5'd3; wDin = 32'h33334444;
            @(posedge clk);
            wEna = 0;


            r1Addr = 5'd2;
            r2Addr = 5'd3;
            #2;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();

            @(posedge clk);
            wEna = 0;
            wAddr = 5'd15;
            wDin = 32'hFFFFFFFF;
            @(posedge clk);

            r1Addr = 5'd15;
            r2Addr = 5'd15;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Register Check (0 and 31)", test_num);
            reset_dut();

            @(posedge clk);
            wEna = 1; wAddr = 5'd0; wDin = 32'hAAAA5555;
            @(posedge clk);
            wAddr = 5'd31; wDin = 32'h5555AAAA;
            @(posedge clk);
            wEna = 0;

            r1Addr = 5'd0;
            r2Addr = 5'd31;
            #2;
            #1;

            check_outputs(32'hAAAA5555, 32'h5555AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Read/Write Timing", test_num);
            reset_dut();

            @(posedge clk);
            wEna = 1;
            wAddr = 5'd10;
            wDin = 32'h12345678;
            r1Addr = 5'd10;
            @(posedge clk);
            wEna = 0;


            r1Addr = 5'd10;
            r2Addr = 5'd10;
            #2;
            #1;

            check_outputs(32'h12345678, 32'h12345678);
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
        input [31:0] expected_r1Dout;
        input [31:0] expected_r2Dout;
        begin
            if (expected_r1Dout === (expected_r1Dout ^ r1Dout ^ expected_r1Dout) &&
                expected_r2Dout === (expected_r2Dout ^ r2Dout ^ expected_r2Dout)) begin
                $display("PASS");
                $display("  Outputs: r1Dout=%h, r2Dout=%h",
                         r1Dout, r2Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r1Dout=%h, r2Dout=%h",
                         expected_r1Dout, expected_r2Dout);
                $display("  Got:      r1Dout=%h, r2Dout=%h",
                         r1Dout, r2Dout);
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
        $dumpvars(0,clk, r1Addr, r2Addr, rst_n, wAddr, wDin, wEna, r1Dout, r2Dout);
    end

endmodule
