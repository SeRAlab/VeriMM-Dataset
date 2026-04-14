`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Address;
    reg Clk;
    reg MemWrite;
    reg [31:0] WriteData;
    wire [31:0] MemData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Clk(Clk),
        .MemWrite(MemWrite),
        .WriteData(WriteData),
        .MemData(MemData)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Address = 16'h0;
        MemWrite = 1'b0;
        WriteData = 32'h0;
        @(posedge Clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Write and Read", test_num);
        reset_dut();

        Address = 16'h0001;
        WriteData = 32'hDEADBEEF;
        MemWrite = 1'b1;
        @(posedge Clk);
        #2;
        MemWrite = 1'b0;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Address Write (0xFFFF)", test_num);
        reset_dut();

        Address = 16'hFFFF;
        WriteData = 32'hCAFEBABE;
        MemWrite = 1'b1;
        @(posedge Clk);
        #2;
        MemWrite = 1'b0;

        #1;


        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwriting Data", test_num);
        reset_dut();


        Address = 16'h00A0;
        WriteData = 32'h11112222;
        MemWrite = 1'b1;
        @(posedge Clk);
        #2;


        WriteData = 32'h33334444;
        @(posedge Clk);
        #2;
        MemWrite = 1'b0;

        #1;


        check_outputs(32'h33334444);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify MemWrite Control (Disabled)", test_num);
        reset_dut();


        Address = 16'h0005;
        WriteData = 32'hAAAA5555;
        MemWrite = 1'b1;
        @(posedge Clk);
        #2;


        WriteData = 32'h00000000;
        MemWrite = 1'b0;
        @(posedge Clk);
        #2;


        #1;



        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Continuous Read Reflection (Address change)", test_num);
        reset_dut();


        Address = 16'h1000;
        WriteData = 32'h88887777;
        MemWrite = 1'b1;
        @(posedge Clk);
        #2;


        Address = 16'h2000;
        WriteData = 32'h66665555;
        @(posedge Clk);
        #2;

        MemWrite = 1'b0;

        Address = 16'h1000;
        #1;

        #1;


        check_outputs(32'h88887777);
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
        input [31:0] expected_MemData;
        begin
            if (expected_MemData === (expected_MemData ^ MemData ^ expected_MemData)) begin
                $display("PASS");
                $display("  Outputs: MemData=%h",
                         MemData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MemData=%h",
                         expected_MemData);
                $display("  Got:      MemData=%h",
                         MemData);
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
        $dumpvars(0,Address, Clk, MemWrite, WriteData, MemData);
    end

endmodule
