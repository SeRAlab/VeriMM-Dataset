`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] IMData;
    reg IRWr;
    reg clk;
    reg reset;
    wire [31:0] IR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IMData(IMData),
        .IRWr(IRWr),
        .clk(clk),
        .reset(reset),
        .IR(IR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            IRWr = 0;
            IMData = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Successful Write Operation", test_num);
            reset_dut();
            IMData = 32'hA5A5_5A5A;
            IRWr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Disable (IRWr=0) Check", test_num);
            reset_dut();
            IMData = 32'hDEAD_BEEF;
            IRWr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Value Check", test_num);
            reset_dut();

            IMData = 32'h1234_5678;
            IRWr = 1;
            @(posedge clk);
            #1;

            IRWr = 0;
            IMData = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority Check", test_num);
            reset_dut();

            IMData = 32'hCAFE_BABE;
            IRWr = 1;
            @(posedge clk);
            #1;

            IMData = 32'h1111_2222;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Multiple Writes", test_num);
            reset_dut();
            IRWr = 1;

            IMData = 32'h0000_0001;
            @(posedge clk);
            #1;

            IMData = 32'h0000_0002;
            @(posedge clk);
            #1;

            IMData = 32'h0000_0003;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0003);
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
        input [31:0] expected_IR;
        begin
            if (expected_IR === (expected_IR ^ IR ^ expected_IR)) begin
                $display("PASS");
                $display("  Outputs: IR=%h",
                         IR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IR=%h",
                         expected_IR);
                $display("  Got:      IR=%h",
                         IR);
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
        $dumpvars(0,IMData, IRWr, clk, reset, IR);
    end

endmodule
