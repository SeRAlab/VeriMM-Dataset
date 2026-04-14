`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] readaddr1;
    reg we;
    reg [31:0] writeaddr1;
    reg [31:0] writein1;
    wire [31:0] readout1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .readaddr1(readaddr1),
        .we(we),
        .writeaddr1(writeaddr1),
        .writein1(writein1),
        .readout1(readout1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        readaddr1 = 0;
        writeaddr1 = 0;
        writein1 = 0;
        @(posedge clk);
        #1;
        $display("Reset complete.");
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Write and Read", test_num);


        @(posedge clk);
        we = 1;
        writeaddr1 = 32'h10;
        writein1 = 32'hDEADBEEF;

        @(posedge clk);
        we = 0;
        readaddr1 = 32'h10;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTestcase %0d: Write Enable Check (we=0)", test_num);


        @(posedge clk);
        we = 0;
        writeaddr1 = 32'h20;
        writein1 = 32'hCAFEBABE;

        @(posedge clk);
        readaddr1 = 32'h20;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sequential Writes", test_num);


        @(posedge clk);
        we = 1;
        writeaddr1 = 32'h1;
        writein1 = 32'h11111111;


        @(posedge clk);
        writeaddr1 = 32'h2;
        writein1 = 32'h22222222;


        @(posedge clk);
        writeaddr1 = 32'h3;
        writein1 = 32'h33333333;

        @(posedge clk);
        we = 0;
        readaddr1 = 32'h2;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h22222222);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTestcase %0d: Overwrite Address", test_num);


        @(posedge clk);
        we = 1;
        writeaddr1 = 32'hA0;
        writein1 = 32'hAAAA_AAAA;


        @(posedge clk);
        writeaddr1 = 32'hA0;
        writein1 = 32'hBBBB_BBBB;

        @(posedge clk);
        we = 0;
        readaddr1 = 32'hA0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTestcase %0d: All 1s Data Pattern", test_num);

        @(posedge clk);
        we = 1;
        writeaddr1 = 32'hFF;
        writein1 = 32'hFFFF_FFFF;

        @(posedge clk);
        we = 0;
        readaddr1 = 32'hFF;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simultaneous Write and Read (Diff Addr)", test_num);


        @(posedge clk);
        we = 1;
        writeaddr1 = 32'h5;
        writein1 = 32'h5555_5555;


        @(posedge clk);
        we = 1;
        writeaddr1 = 32'h6;
        writein1 = 32'h6666_6666;
        readaddr1 = 32'h5;


        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5555_5555);
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
        input [31:0] expected_readout1;
        begin
            if (expected_readout1 === (expected_readout1 ^ readout1 ^ expected_readout1)) begin
                $display("PASS");
                $display("  Outputs: readout1=%h",
                         readout1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readout1=%h",
                         expected_readout1);
                $display("  Got:      readout1=%h",
                         readout1);
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
        $dumpvars(0,clk, readaddr1, we, writeaddr1, writein1, readout1);
    end

endmodule
