`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] readAdd0;
    reg [4:0] readAdd1;
    reg regWR;
    reg [4:0] writeAdd;
    reg [31:0] writeData;
    wire [31:0] readOutput0;
    wire [31:0] readOutput1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .readAdd0(readAdd0),
        .readAdd1(readAdd1),
        .regWR(regWR),
        .writeAdd(writeAdd),
        .writeData(writeData),
        .readOutput0(readOutput0),
        .readOutput1(readOutput1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            regWR = 1;
            readAdd0 = 0;
            readAdd1 = 0;
            writeAdd = 0;
            writeData = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            writeAdd = 5'd1;
            writeData = 32'hDEADBEEF;
            regWR = 0;
            @(posedge clk);
            #1;
            regWR = 1;


            readAdd0 = 5'd1;
            readAdd1 = 5'd1;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simultaneous Read from Two Registers", test_num);
            reset_dut();


            writeAdd = 5'd2;
            writeData = 32'h12345678;
            regWR = 0;
            @(posedge clk);
            #1;


            writeAdd = 5'd3;
            writeData = 32'h87654321;
            regWR = 0;
            @(posedge clk);
            #1;
            regWR = 1;


            readAdd0 = 5'd2;
            readAdd1 = 5'd3;
            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Write Enable (Active Low)", test_num);
            reset_dut();


            writeAdd = 5'd4;
            writeData = 32'hAAAA_AAAA;
            regWR = 0;
            @(posedge clk);
            #1;


            writeAdd = 5'd4;
            writeData = 32'hFFFF_FFFF;
            regWR = 1;
            @(posedge clk);
            #1;


            readAdd0 = 5'd4;
            readAdd1 = 5'd4;
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Check Register 15", test_num);
            reset_dut();

            writeAdd = 5'd15;
            writeData = 32'h5555_6666;
            regWR = 0;
            @(posedge clk);
            #1;
            regWR = 1;

            readAdd0 = 5'd15;
            readAdd1 = 5'd0;
            #1;
            #1;

            check_outputs(32'h5555_6666, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwriting a Register", test_num);
            reset_dut();


            writeAdd = 5'd7;
            writeData = 32'h1111_1111;
            regWR = 0;
            @(posedge clk);
            #1;


            writeData = 32'h2222_2222;
            @(posedge clk);
            #1;
            regWR = 1;

            readAdd0 = 5'd7;
            readAdd1 = 5'd7;
            #1;
            #1;

            check_outputs(32'h2222_2222, 32'h2222_2222);
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
        input [31:0] expected_readOutput0;
        input [31:0] expected_readOutput1;
        begin
            if (expected_readOutput0 === (expected_readOutput0 ^ readOutput0 ^ expected_readOutput0) &&
                expected_readOutput1 === (expected_readOutput1 ^ readOutput1 ^ expected_readOutput1)) begin
                $display("PASS");
                $display("  Outputs: readOutput0=%h, readOutput1=%h",
                         readOutput0, readOutput1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readOutput0=%h, readOutput1=%h",
                         expected_readOutput0, expected_readOutput1);
                $display("  Got:      readOutput0=%h, readOutput1=%h",
                         readOutput0, readOutput1);
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
        $dumpvars(0,clk, readAdd0, readAdd1, regWR, writeAdd, writeData, readOutput0, readOutput1);
    end

endmodule
