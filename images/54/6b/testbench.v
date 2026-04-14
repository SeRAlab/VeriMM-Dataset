`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] DataIn;
    reg Reset;
    reg Set;
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
        .Set(Set),
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
            Set = 0;
            Write = 0;
            DataIn = 8'h00;
            @(posedge Clk);
            #1;
            Reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Reset (Priority 1)", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Set (Priority 2)", test_num);
            reset_dut();
            @(negedge Clk);
            Set = 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing Write (Priority 3)", test_num);
            reset_dut();
            @(negedge Clk);
            Write = 1;
            DataIn = 8'hA5;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing Priority - Reset over Set", test_num);
            reset_dut();
            @(negedge Clk);
            Reset = 1;
            Set = 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Priority - Set over Write", test_num);
            reset_dut();
            @(negedge Clk);
            Set = 1;
            Write = 1;
            DataIn = 8'h33;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing Priority - Reset over Write", test_num);
            reset_dut();
            @(negedge Clk);
            Reset = 1;
            Write = 1;
            DataIn = 8'h55;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Testing Hold Value", test_num);
            reset_dut();

            @(negedge Clk);
            Write = 1;
            DataIn = 8'h66;
            @(posedge Clk);
            #1;

            @(negedge Clk);
            Write = 0;
            DataIn = 8'h99;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Testing Multiple Sequential Writes", test_num);
            reset_dut();
            @(negedge Clk);
            Write = 1;
            DataIn = 8'h11;
            @(posedge Clk);
            @(negedge Clk);
            DataIn = 8'h22;
            @(posedge Clk);
            @(negedge Clk);
            DataIn = 8'h33;
            @(posedge Clk);
            #1;
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
        testcase008();
        
        
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
        $dumpvars(0,Clk, DataIn, Reset, Set, Write, DataOut);
    end

endmodule
