`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] add1;
    reg [2:0] add2;
    reg clk;
    reg rst;
    reg we1;
    reg we2;
    reg [15:0] wr1;
    reg [15:0] wr2;
    wire mem_fault;
    wire [15:0] rd1;
    wire [15:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add1(add1),
        .add2(add2),
        .clk(clk),
        .rst(rst),
        .we1(we1),
        .we2(we2),
        .wr1(wr1),
        .wr2(wr2),
        .mem_fault(mem_fault),
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
            rst = 1;
            we1 = 0;
            we2 = 0;
            add1 = 0;
            add2 = 0;
            wr1 = 0;
            wr2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            we1 = 1; add1 = 3'd1; wr1 = 16'hAAAA;
            we2 = 0;
            @(posedge clk);

            we1 = 0; add1 = 3'd1; add2 = 3'd1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 16'hAAAA, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            we1 = 0;
            we2 = 1; add2 = 3'd7; wr2 = 16'h5555;
            @(posedge clk);

            we2 = 0; add2 = 3'd7; add1 = 3'd0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 16'h0000, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            we1 = 1; add1 = 3'd2; wr1 = 16'h1234;
            we2 = 1; add2 = 3'd3; wr2 = 16'h5678;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'h1234, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            we1 = 1; add1 = 3'd2; we2 = 1; add2 = 3'd3;
            @(posedge clk);

            reset_dut();
            #1;

            check_outputs(1'b0, 16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            we1 = 1; add1 = 3'd4; wr1 = 16'hBBBB;
            we2 = 1; add2 = 3'd4; wr2 = 16'hCCCC;
            @(posedge clk);


            we1 = 0; we2 = 0; add1 = 3'd4;
            @(posedge clk);
            #1;

            check_outputs(1'b0, rd1, rd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            we1 = 1; add1 = 3'd5; wr1 = 16'hFEED;
            @(posedge clk);

            we1 = 1; add1 = 3'd6; wr1 = 16'hBEEF;
            add2 = 3'd5;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 16'hBEEF, 16'hFEED);
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
        input expected_mem_fault;
        input [15:0] expected_rd1;
        input [15:0] expected_rd2;
        begin
            if (expected_mem_fault === (expected_mem_fault ^ mem_fault ^ expected_mem_fault) &&
                expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: mem_fault=%b, rd1=%h, rd2=%h",
                         mem_fault, rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_fault=%b, rd1=%h, rd2=%h",
                         expected_mem_fault, expected_rd1, expected_rd2);
                $display("  Got:      mem_fault=%b, rd1=%h, rd2=%h",
                         mem_fault, rd1, rd2);
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
        $dumpvars(0,add1, add2, clk, rst, we1, we2, wr1, wr2, mem_fault, rd1, rd2);
    end

endmodule
