`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] dataa;
    reg [11:0] datab;
    wire [23:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataa(dataa),
        .datab(datab),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        dataa = 12'd0;
        datab = 12'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Positive", test_num);
        reset_dut();
        dataa = 12'sd15;
        datab = 12'sd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'sd150);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative", test_num);
        reset_dut();
        dataa = 12'sd20;
        datab = -12'sd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(-24'sd100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative", test_num);
        reset_dut();
        dataa = -12'sd12;
        datab = -12'sd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'sd48);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Multiplication", test_num);
        reset_dut();
        dataa = 12'sd0;
        datab = -12'sd1024;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive Squared", test_num);
        reset_dut();
        dataa = 12'sh7FF;
        datab = 12'sh7FF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'sd4190209);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Negative Squared", test_num);
        reset_dut();
        dataa = 12'sh800;
        datab = 12'sh800;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'sd4194304);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Negative * Max Positive", test_num);
        reset_dut();
        dataa = 12'sh800;
        datab = 12'sh7FF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(-24'sd4192256);
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
        input [23:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,clk, dataa, datab, dataout);
    end

endmodule
