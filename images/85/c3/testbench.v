`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Address;
    reg MemRead;
    reg MemWrite;
    reg [31:0] Write_data;
    reg clk;
    wire [31:0] Read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Write_data(Write_data),
        .clk(clk),
        .Read_data(Read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        Address = 0;
        Write_data = 0;
        MemRead = 0;
        MemWrite = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read", test_num);
        reset_dut();


        Address = 32'd4;
        Write_data = 32'hDEADBEEF;
        MemWrite = 1;
        @(posedge clk);
        #2 MemWrite = 0;


        MemRead = 1;
        @(negedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Address Alignment Check", test_num);
        reset_dut();


        Address = 32'd8;
        Write_data = 32'h11112222;
        MemWrite = 1;
        @(posedge clk);
        #2;


        Address = 32'd12;
        Write_data = 32'h33334444;
        MemWrite = 1;
        @(posedge clk);
        #2 MemWrite = 0;


        Address = 32'd8;
        MemRead = 1;
        @(negedge clk);
        #2;
        #1;

        check_outputs(32'h11112222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: MemWrite Enable Verification", test_num);
        reset_dut();


        Address = 32'd20;
        Write_data = 32'hAAAA5555;
        MemWrite = 1;
        @(posedge clk);
        #2;


        Write_data = 32'h00000000;
        MemWrite = 0;
        @(posedge clk);
        #2;


        MemRead = 1;
        @(negedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Same-Cycle Write/Read", test_num);
        reset_dut();

        Address = 32'd40;
        Write_data = 32'hBCBCBCBC;
        MemWrite = 1;
        MemRead = 1;


        @(posedge clk);

        @(negedge clk);
        #2;
        #1;

        check_outputs(32'hBCBCBCBC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: MemRead Signal Verification", test_num);
        reset_dut();


        Address = 32'd0;
        Write_data = 32'h99887766;
        MemWrite = 1;
        @(posedge clk);
        #2 MemWrite = 0;




        MemRead = 0;
        @(negedge clk);
        #2;

        if (Read_data !== 32'h99887766) begin
            $display("PASS: Read_data did not update when MemRead was 0");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Read_data updated even though MemRead was 0");
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
        input [31:0] expected_Read_data;
        begin
            if (expected_Read_data === (expected_Read_data ^ Read_data ^ expected_Read_data)) begin
                $display("PASS");
                $display("  Outputs: Read_data=%h",
                         Read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Read_data=%h",
                         expected_Read_data);
                $display("  Got:      Read_data=%h",
                         Read_data);
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
        $dumpvars(0,Address, MemRead, MemWrite, Write_data, clk, Read_data);
    end

endmodule
