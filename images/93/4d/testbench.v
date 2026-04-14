`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] a0;
    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;
    reg clk;
    reg [31:0] wd3;
    reg we3;
    wire [31:0] rd0;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .clk(clk),
        .wd3(wd3),
        .we3(we3),
        .rd0(rd0),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a0 = 0;
            a1 = 0;
            a2 = 0;
            a3 = 0;
            wd3 = 0;
            we3 = 0;
            @(posedge clk);
            #1;
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Multi-port Read", test_num);
            reset_dut();


            we3 = 1;
            a3 = 5;
            wd3 = 32'hACE12345;
            @(posedge clk);
            #1;


            we3 = 0;
            a0 = 5;
            a1 = 5;
            a2 = 5;
            #1;

            #1;


            check_outputs(32'hACE12345, 32'hACE12345, 32'hACE12345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Registers and Simultaneous Read", test_num);
            reset_dut();


            we3 = 1; a3 = 10; wd3 = 32'hAAAA_AAAA;
            @(posedge clk); #1;


            we3 = 1; a3 = 20; wd3 = 32'hBBBB_BBBB;
            @(posedge clk); #1;


            we3 = 1; a3 = 30; wd3 = 32'hCCCC_CCCC;
            @(posedge clk); #1;


            we3 = 0;
            a0 = 10;
            a1 = 20;
            a2 = 30;
            #1;

            #1;


            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Verification", test_num);
            reset_dut();


            we3 = 1; a3 = 15; wd3 = 32'h1111_1111;
            @(posedge clk); #1;


            we3 = 0; a3 = 15; wd3 = 32'hEEEE_EEEE;
            @(posedge clk); #1;


            a0 = 15;
            a1 = 15;
            a2 = 15;
            #1;

            #1;


            check_outputs(32'h1111_1111, 32'h1111_1111, 32'h1111_1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register 0 Access", test_num);
            reset_dut();

            we3 = 1; a3 = 0; wd3 = 32'hFFFF_FFFF;
            @(posedge clk); #1;

            a0 = 0; a1 = 0; a2 = 0;
            #1;



            #1;




            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register 31 (Boundary) Access", test_num);
            reset_dut();

            we3 = 1; a3 = 31; wd3 = 32'h55AA_55AA;
            @(posedge clk); #1;

            a0 = 31; a1 = 31; a2 = 31;
            #1;

            #1;


            check_outputs(32'h55AA_55AA, 32'h55AA_55AA, 32'h55AA_55AA);
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
        input [31:0] expected_rd0;
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd0 === (expected_rd0 ^ rd0 ^ expected_rd0) &&
                expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd0=%h, rd1=%h, rd2=%h",
                         rd0, rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd0=%h, rd1=%h, rd2=%h",
                         expected_rd0, expected_rd1, expected_rd2);
                $display("  Got:      rd0=%h, rd1=%h, rd2=%h",
                         rd0, rd1, rd2);
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
        $dumpvars(0,a0, a1, a2, a3, clk, wd3, we3, rd0, rd1, rd2);
    end

endmodule
