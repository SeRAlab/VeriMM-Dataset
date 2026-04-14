`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [2:0] readSelectA_in;
    reg [2:0] readSelectB_in;
    reg reset_in;
    reg writeEnableR0_in;
    reg writeEnableR1_in;
    reg [7:0] writeValueR0_in;
    reg [7:0] writeValueR1_in;
    wire [7:0] readResultA_out;
    wire [7:0] readResultB_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .readSelectA_in(readSelectA_in),
        .readSelectB_in(readSelectB_in),
        .reset_in(reset_in),
        .writeEnableR0_in(writeEnableR0_in),
        .writeEnableR1_in(writeEnableR1_in),
        .writeValueR0_in(writeValueR0_in),
        .writeValueR1_in(writeValueR1_in),
        .readResultA_out(readResultA_out),
        .readResultB_out(readResultB_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        reset_in = 1;
        writeEnableR0_in = 0;
        writeEnableR1_in = 0;
        writeValueR0_in = 0;
        writeValueR1_in = 0;
        readSelectA_in = 0;
        readSelectB_in = 0;
        @(posedge clk_in);
        #1;
        reset_in = 0;
        @(posedge clk_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Verify Reset State", test_num);
        reset_dut();

        readSelectA_in = 3'd6;
        readSelectB_in = 3'd7;
        #5;

        #1;


        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Write and Read Register 0", test_num);
        reset_dut();

        writeValueR0_in = 8'hA5;
        writeEnableR0_in = 1;
        @(posedge clk_in);
        #1;
        writeEnableR0_in = 0;

        readSelectA_in = 3'd6;
        readSelectB_in = 3'd6;
        #5;

        #1;


        check_outputs(8'hA5, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Write and Read Register 1", test_num);
        reset_dut();

        writeValueR1_in = 8'h5A;
        writeEnableR1_in = 1;
        @(posedge clk_in);
        #1;
        writeEnableR1_in = 0;

        readSelectA_in = 3'd7;
        readSelectB_in = 3'd7;
        #5;

        #1;


        check_outputs(8'h5A, 8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Verify Constant Values (Addr 2 and 5)", test_num);
        reset_dut();

        readSelectA_in = 3'd2;
        readSelectB_in = 3'd5;
        #5;

        #1;


        check_outputs(8'h02, 8'h05);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Simultaneous Write", test_num);
        reset_dut();

        writeValueR0_in = 8'h11;
        writeValueR1_in = 8'h22;
        writeEnableR0_in = 1;
        writeEnableR1_in = 1;
        @(posedge clk_in);
        #1;
        writeEnableR0_in = 0;
        writeEnableR1_in = 0;

        readSelectA_in = 3'd6;
        readSelectB_in = 3'd7;
        #5;

        #1;


        check_outputs(8'h11, 8'h22);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Write Enable Check (Disabled)", test_num);
        reset_dut();

        writeValueR0_in = 8'hFF;
        writeEnableR0_in = 0;
        @(posedge clk_in);
        #1;

        readSelectA_in = 3'd6;
        readSelectB_in = 3'd0;
        #5;

        #1;


        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Sequential Overwrite", test_num);
        reset_dut();


        writeValueR1_in = 8'hAA;
        writeEnableR1_in = 1;
        @(posedge clk_in);
        #1;


        writeValueR1_in = 8'hBB;
        writeEnableR1_in = 1;
        @(posedge clk_in);
        #1;
        writeEnableR1_in = 0;

        readSelectA_in = 3'd7;
        readSelectB_in = 3'd7;
        #5;

        #1;


        check_outputs(8'hBB, 8'hBB);
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
        testcase007();
        
        
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
        input [7:0] expected_readResultA_out;
        input [7:0] expected_readResultB_out;
        begin
            if (expected_readResultA_out === (expected_readResultA_out ^ readResultA_out ^ expected_readResultA_out) &&
                expected_readResultB_out === (expected_readResultB_out ^ readResultB_out ^ expected_readResultB_out)) begin
                $display("PASS");
                $display("  Outputs: readResultA_out=%h, readResultB_out=%h",
                         readResultA_out, readResultB_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readResultA_out=%h, readResultB_out=%h",
                         expected_readResultA_out, expected_readResultB_out);
                $display("  Got:      readResultA_out=%h, readResultB_out=%h",
                         readResultA_out, readResultB_out);
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
        $dumpvars(0,clk_in, readSelectA_in, readSelectB_in, reset_in, writeEnableR0_in, writeEnableR1_in, writeValueR0_in, writeValueR1_in, readResultA_out, readResultB_out);
    end

endmodule
