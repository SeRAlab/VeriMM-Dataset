`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Current_Address;
    reg [7:0] IA;
    reg clk;
    reg reset;
    wire [7:0] Hold_Address;
    wire [7:0] Next_Address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Current_Address(Current_Address),
        .IA(IA),
        .clk(clk),
        .reset(reset),
        .Hold_Address(Hold_Address),
        .Next_Address(Next_Address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        Current_Address = 8'h00;
        IA = 8'h00;
        @(posedge clk);
        #1;
        reset = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior Verification", test_num);

        Current_Address = 8'hFF;
        IA = 8'hFF;
        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Register Update (AA, 55)", test_num);
        reset_dut();
        Current_Address = 8'hAA;
        IA = 8'h55;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Register Update (12, 34)", test_num);
        reset_dut();
        Current_Address = 8'h12;
        IA = 8'h34;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h12, 8'h34);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Clock Cycle Update", test_num);
        reset_dut();

        Current_Address = 8'hA1;
        IA = 8'hB2;
        @(posedge clk);

        #1;
        Current_Address = 8'hC3;
        IA = 8'hD4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hC3, 8'hD4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Values (FF, 00)", test_num);
        reset_dut();
        Current_Address = 8'hFF;
        IA = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF, 8'h00);
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
        input [7:0] expected_Hold_Address;
        input [7:0] expected_Next_Address;
        begin
            if (expected_Hold_Address === (expected_Hold_Address ^ Hold_Address ^ expected_Hold_Address) &&
                expected_Next_Address === (expected_Next_Address ^ Next_Address ^ expected_Next_Address)) begin
                $display("PASS");
                $display("  Outputs: Hold_Address=%h, Next_Address=%h",
                         Hold_Address, Next_Address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Hold_Address=%h, Next_Address=%h",
                         expected_Hold_Address, expected_Next_Address);
                $display("  Got:      Hold_Address=%h, Next_Address=%h",
                         Hold_Address, Next_Address);
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
        $dumpvars(0,Current_Address, IA, clk, reset, Hold_Address, Next_Address);
    end

endmodule
