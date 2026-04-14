`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegWrite;
    reg clk;
    reg [4:0] r1;
    reg [4:0] r2;
    reg rst;
    reg [4:0] w;
    reg [31:0] wdata;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite(RegWrite),
        .clk(clk),
        .r1(r1),
        .r2(r2),
        .rst(rst),
        .w(w),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        RegWrite = 0;
        r1 = 0;
        r2 = 0;
        w = 0;
        wdata = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Post-Reset Read (R5, R10)", test_num);
        r1 = 5;
        r2 = 10;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Write to R1 and Read back", test_num);


        @(negedge clk);
        RegWrite = 1;
        w = 5'd1;
        wdata = 32'hDEADBEEF;
        @(posedge clk);
        #1 RegWrite = 0;


        r1 = 5'd1;
        r2 = 5'd0;
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Attempt Write to R0", test_num);

        @(negedge clk);
        RegWrite = 1;
        w = 5'd0;
        wdata = 32'hFFFFFFFF;
        @(posedge clk);
        #1 RegWrite = 0;

        r1 = 5'd0;
        r2 = 5'd1;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Dual Read (R10 and R20)", test_num);


        @(negedge clk);
        RegWrite = 1; w = 5'd10; wdata = 32'h12345678;
        @(posedge clk);


        @(negedge clk);
        w = 5'd20; wdata = 32'h87654321;
        @(posedge clk);
        #1 RegWrite = 0;

        r1 = 5'd10;
        r2 = 5'd20;
        #1;
        #1;

        check_outputs(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Write while RegWrite is 0", test_num);

        @(negedge clk);
        RegWrite = 0;
        w = 5'd15;
        wdata = 32'hAAAA5555;
        @(posedge clk);

        r1 = 5'd15;
        r2 = 0;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Boundary Register R31", test_num);

        @(negedge clk);
        RegWrite = 1;
        w = 5'd31;
        wdata = 32'hBCBCBCBC;
        @(posedge clk);
        #1 RegWrite = 0;

        r1 = 5'd31;
        r2 = 5'd31;
        #1;
        #1;

        check_outputs(32'hBCBCBCBC, 32'hBCBCBCBC);
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,RegWrite, clk, r1, r2, rst, w, wdata, rdata1, rdata2);
    end

endmodule
