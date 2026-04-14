`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] readregA;
    reg [4:0] readregB;
    reg [31:0] writedata;
    reg writeflag;
    reg [4:0] writereg;
    wire [31:0] dataA;
    wire [31:0] dataB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .readregA(readregA),
        .readregB(readregB),
        .writedata(writedata),
        .writeflag(writeflag),
        .writereg(writereg),
        .dataA(dataA),
        .dataB(dataB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        readregA = 0;
        readregB = 0;
        writedata = 0;
        writeflag = 0;
        writereg = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running Testcase001: Register 0 Constant Zero Check");


        writereg = 5'd0;
        writedata = 32'hFFFFFFFF;
        writeflag = 1;
        @(posedge clk);
        #2;
        writeflag = 0;


        readregA = 5'd0;
        readregB = 5'd0;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running Testcase002: Basic Write/Read Check (Reg 1)");

        writereg = 5'd1;
        writedata = 32'hABCD1234;
        writeflag = 1;
        @(posedge clk);
        #2;
        writeflag = 0;

        readregA = 5'd1;
        readregB = 5'd0;
        #1;
        #1;

        check_outputs(32'hABCD1234, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running Testcase003: Dual Port Simultaneous Read Check");


        writereg = 5'd5;
        writedata = 32'h5555_5555;
        writeflag = 1;
        @(posedge clk);
        #2;


        writereg = 5'd10;
        writedata = 32'hAAAA_AAAA;
        writeflag = 1;
        @(posedge clk);
        #2;
        writeflag = 0;


        readregA = 5'd5;
        readregB = 5'd10;
        #1;
        #1;

        check_outputs(32'h5555_5555, 32'hAAAA_AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running Testcase004: Write-Enable Flag Check");


        writereg = 5'd7;
        writedata = 32'h1111_1111;
        writeflag = 1;
        @(posedge clk);
        #2;


        writereg = 5'd7;
        writedata = 32'hEEEE_EEEE;
        writeflag = 0;
        @(posedge clk);
        #2;

        readregA = 5'd7;
        readregB = 5'd0;
        #1;

        #1;


        check_outputs(32'h1111_1111, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running Testcase005: Boundary Register (Reg 31) Check");

        writereg = 5'd31;
        writedata = 32'h7FFFFFFF;
        writeflag = 1;
        @(posedge clk);
        #2;
        writeflag = 0;

        readregA = 5'd31;
        readregB = 5'd31;
        #1;
        #1;

        check_outputs(32'h7FFFFFFF, 32'h7FFFFFFF);
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
        input [31:0] expected_dataA;
        input [31:0] expected_dataB;
        begin
            if (expected_dataA === (expected_dataA ^ dataA ^ expected_dataA) &&
                expected_dataB === (expected_dataB ^ dataB ^ expected_dataB)) begin
                $display("PASS");
                $display("  Outputs: dataA=%h, dataB=%h",
                         dataA, dataB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataA=%h, dataB=%h",
                         expected_dataA, expected_dataB);
                $display("  Got:      dataA=%h, dataB=%h",
                         dataA, dataB);
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
        $dumpvars(0,clk, readregA, readregB, writedata, writeflag, writereg, dataA, dataB);
    end

endmodule
