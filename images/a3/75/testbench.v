`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] DataIn;
    reg [7:0] Default;
    reg Reset;
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
        .Default(Default),
        .Reset(Reset),
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
            @(posedge Clk);
            Reset = 1;
            Write = 0;
            DataIn = 8'h00;
            Default = 8'h00;
            @(posedge Clk);
            #1 Reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset to Default Value", test_num);
            reset_dut();

            Default = 8'hA5;
            Reset = 1;
            @(posedge Clk);
            #1 Reset = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write DataIn to Register", test_num);
            reset_dut();

            DataIn = 8'h5A;
            Write = 1;
            @(posedge Clk);
            #1 Write = 0;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Retention when Write=0", test_num);
            reset_dut();


            DataIn = 8'h12;
            Write = 1;
            @(posedge Clk);
            #1;


            Write = 0;
            DataIn = 8'hFF;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority over Write signal", test_num);
            reset_dut();

            Default = 8'hDE;
            DataIn = 8'hAD;
            Reset = 1;
            Write = 1;
            @(posedge Clk);
            #1 Reset = 0;
            Write = 0;

            #1;


            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Writing 8'h00", test_num);
            reset_dut();

            DataIn = 8'h00;
            Write = 1;
            @(posedge Clk);
            #1 Write = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Writing 8'hFF", test_num);
            reset_dut();

            DataIn = 8'hFF;
            Write = 1;
            @(posedge Clk);
            #1 Write = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Changing Default and Reseting", test_num);
            reset_dut();

            Default = 8'h33;
            Reset = 1;
            @(posedge Clk);
            #1;
            Default = 8'hCC;
            Reset = 1;
            @(posedge Clk);
            #1 Reset = 0;

            #1;


            check_outputs(8'hCC);
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
        $dumpvars(0,Clk, DataIn, Default, Reset, Write, DataOut);
    end

endmodule
