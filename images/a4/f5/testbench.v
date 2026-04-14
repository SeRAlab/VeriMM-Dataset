`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ACC_output;
    reg C11;
    reg C17;
    reg C18;
    reg C3;
    reg [15:0] DR_output;
    reg [15:0] MR_output;
    reg [15:0] RAM_output;
    reg clk;
    wire [15:0] MBR_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACC_output(ACC_output),
        .C11(C11),
        .C17(C17),
        .C18(C18),
        .C3(C3),
        .DR_output(DR_output),
        .MR_output(MR_output),
        .RAM_output(RAM_output),
        .clk(clk),
        .MBR_output(MBR_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            C11 = 0;
            C17 = 0;
            C18 = 0;
            C3 = 0;
            ACC_output = 16'h0000;
            MR_output = 16'h0000;
            DR_output = 16'h0000;
            RAM_output = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select ACC (C11=1)", test_num);
            reset_dut();
            ACC_output = 16'hAAAA;
            C11 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select MR (C17=1)", test_num);
            reset_dut();
            MR_output = 16'h5555;
            C17 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select DR (C18=1)", test_num);
            reset_dut();
            DR_output = 16'h1234;
            C18 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select RAM (C3=1)", test_num);
            reset_dut();
            RAM_output = 16'hFEDC;
            C3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFEDC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold Previous Value (All controls 0)", test_num);
            reset_dut();


            ACC_output = 16'h8888;
            C11 = 1;
            @(posedge clk);
            #2;


            C11 = 0;
            ACC_output = 16'hFFFF;
            MR_output = 16'hFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h8888);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Test Full Range Data Load", test_num);
            reset_dut();
            DR_output = 16'hFFFF;
            C18 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_MBR_output;
        begin
            if (expected_MBR_output === (expected_MBR_output ^ MBR_output ^ expected_MBR_output)) begin
                $display("PASS");
                $display("  Outputs: MBR_output=%h",
                         MBR_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MBR_output=%h",
                         expected_MBR_output);
                $display("  Got:      MBR_output=%h",
                         MBR_output);
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
        $dumpvars(0,ACC_output, C11, C17, C18, C3, DR_output, MR_output, RAM_output, clk, MBR_output);
    end

endmodule
