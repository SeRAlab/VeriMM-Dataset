`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] DataIn;
    reg Reset;
    reg SyncReset;
    reg Write;
    wire [7:0] DataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .DataIn(DataIn),
        .Reset(Reset),
        .SyncReset(SyncReset),
        .Write(Write),
        .DataOut(DataOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            SyncReset = 0;
            Write = 0;
            DataIn = 8'h00;
            #12;
            Reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Write Operation", test_num);
            reset_dut();
            @(posedge Clk);
            DataIn = 8'hAA;
            Write = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Write Enable Verification (Write=0)", test_num);
            reset_dut();

            @(posedge Clk);
            DataIn = 8'h55;
            Write = 1;
            @(posedge Clk);
            #2;

            DataIn = 8'hFF;
            Write = 0;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Synchronous Reset Verification", test_num);
            reset_dut();

            @(posedge Clk);
            DataIn = 8'h33;
            Write = 1;
            @(posedge Clk);
            #2;

            SyncReset = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Priority Check (SyncReset over Write)", test_num);
            reset_dut();
            @(posedge Clk);
            DataIn = 8'hCC;
            Write = 1;
            SyncReset = 1;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Async Reset Mid-Operation", test_num);
            reset_dut();
            @(posedge Clk);
            DataIn = 8'h77;
            Write = 1;
            @(posedge Clk);
            #2;

            #3 Reset = 1;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Continuous Sequential Writes", test_num);
            reset_dut();
            @(posedge Clk);
            Write = 1;
            DataIn = 8'h11;
            @(posedge Clk);
            #1;
            DataIn = 8'h22;
            @(posedge Clk);
            #1;
            DataIn = 8'h33;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_DataOut;
        begin
            if (expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut)) begin
                $display("PASS");
                $display("  Outputs: DataOut=%h",
                         DataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut=%h",
                         expected_DataOut);
                $display("  Got:      DataOut=%h",
                         DataOut);
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
        $dumpvars(0,Clk, DataIn, Reset, SyncReset, Write, DataOut);
    end

endmodule
