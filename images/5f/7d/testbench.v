`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [31:0] Data;
    reg Enable;
    wire [31:0] Shifted_Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Data(Data),
        .Enable(Enable),
        .Shifted_Data(Shifted_Data)
    );

        task reset_dut;

    begin
        Enable = 0;
        Data = 32'h0;
        @(posedge Clock);
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        Data = 32'hA5A5A5A5;
        Enable = 0;
        @(posedge Clock);
        #10;
        $display("Testcase %0d: Load check (Enable=0)", test_num);
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Data = 32'h00000002;
        Enable = 0;
        @(posedge Clock);
        #10;
        Enable = 1;
        @(posedge Clock);
        #10;
        $display("Testcase %0d: Single shift check", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Data = 32'hF0000000;
        Enable = 0;
        @(posedge Clock);
        #10;
        Enable = 1;
        repeat (4) @(posedge Clock);
        #10;
        $display("Testcase %0d: Multiple shifts check (4 bits)", test_num);
        #1;

        check_outputs(32'h0F000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Data = 32'h80000000;
        Enable = 0;
        @(posedge Clock);
        #10;
        Enable = 1;
        repeat (32) @(posedge Clock);
        #10;
        $display("Testcase %0d: Shift until zero check", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Data = 32'hFFFFFFFF;
        Enable = 0;
        @(posedge Clock);
        #10;
        Enable = 1;
        @(posedge Clock);
        #10;
        Enable = 0;
        @(posedge Clock);
        #10;
        $display("Testcase %0d: Return to Data when Enable=0 check", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_Shifted_Data;
        begin
            if (expected_Shifted_Data === (expected_Shifted_Data ^ Shifted_Data ^ expected_Shifted_Data)) begin
                $display("PASS");
                $display("  Outputs: Shifted_Data=%h",
                         Shifted_Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Shifted_Data=%h",
                         expected_Shifted_Data);
                $display("  Got:      Shifted_Data=%h",
                         Shifted_Data);
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
        $dumpvars(0,Clock, Data, Enable, Shifted_Data);
    end

endmodule
