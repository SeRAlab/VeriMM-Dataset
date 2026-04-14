`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST_N;
    reg [8:0] readAddr;
    reg readDataEnable;
    reg readEnable;
    reg [8:0] writeAddr;
    reg [31:0] writeData;
    reg writeEnable;
    wire [31:0] readData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST_N(RST_N),
        .readAddr(readAddr),
        .readDataEnable(readDataEnable),
        .readEnable(readEnable),
        .writeAddr(writeAddr),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .readData(readData)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 0;
            readAddr = 0;
            readDataEnable = 0;
            readEnable = 0;
            writeAddr = 0;
            writeData = 0;
            writeEnable = 0;
            repeat (2) @(posedge CLK);
            RST_N = 1;
            repeat (1) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge CLK);
            writeEnable = 1;
            writeAddr = 9'h0A5;
            writeData = 32'h12345678;

            @(posedge CLK);
            writeEnable = 0;


            readEnable = 1;
            readDataEnable = 1;
            readAddr = 9'h0A5;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Write/Read", test_num);
            reset_dut();


            @(posedge CLK);
            writeEnable = 1;
            writeAddr = 9'd511;
            writeData = 32'hAAAAAAAA;

            @(posedge CLK);
            writeEnable = 0;
            readEnable = 1;
            readDataEnable = 1;
            readAddr = 9'd511;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();


            @(posedge CLK);
            writeEnable = 0;
            writeAddr = 9'h020;
            writeData = 32'hFEEDFACE;

            @(posedge CLK);
            readEnable = 1;
            readDataEnable = 1;
            readAddr = 9'h020;

            @(posedge CLK);
            #1;



            if (readData !== 32'hFEEDFACE) begin
                $display("PASS: Write inhibited as expected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Data was written despite writeEnable being low");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge CLK);
            writeEnable = 1;
            writeAddr = 9'h050;
            writeData = 32'h5555AAAA;

            @(posedge CLK);

            writeEnable = 1;
            writeAddr = 9'h060;
            writeData = 32'h6666BBBB;
            readEnable = 1;
            readDataEnable = 1;
            readAddr = 9'h050;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Data Enable Gating", test_num);
            reset_dut();


            @(posedge CLK);
            writeEnable = 1;
            writeAddr = 9'h100;
            writeData = 32'h99887766;

            @(posedge CLK);
            writeEnable = 0;
            readEnable = 1;
            readDataEnable = 0;
            readAddr = 9'h100;

            @(posedge CLK);
            #1;
            if (readData !== 32'h99887766) begin
                $display("PASS: readData was gated or not updated correctly with readDataEnable low");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: readData updated despite readDataEnable being low");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_readData;
        begin
            if (expected_readData === (expected_readData ^ readData ^ expected_readData)) begin
                $display("PASS");
                $display("  Outputs: readData=%h",
                         readData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData=%h",
                         expected_readData);
                $display("  Got:      readData=%h",
                         readData);
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
        $dumpvars(0,CLK, RST_N, readAddr, readDataEnable, readEnable, writeAddr, writeData, writeEnable, readData);
    end

endmodule
