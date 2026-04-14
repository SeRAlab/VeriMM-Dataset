`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear;
    reg Clock;
    reg Ten;
    reg Twenty;
    wire Bill;
    wire Dispense;
    wire Ready;
    wire Return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear(Clear),
        .Clock(Clock),
        .Ten(Ten),
        .Twenty(Twenty),
        .Bill(Bill),
        .Dispense(Dispense),
        .Ready(Ready),
        .Return(Return)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

    begin
        Clear = 1;
        Ten = 0;
        Twenty = 0;
        @(posedge Clock);
        #1;
        Clear = 0;
        @(posedge Clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Check initial state after reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Insert 10, 10, 10 (Exact amount)", test_num);
        reset_dut();


        Ten = 1; @(posedge Clock); #1; Ten = 0; @(posedge Clock); #1;

        Ten = 1; @(posedge Clock); #1; Ten = 0; @(posedge Clock); #1;

        Ten = 1; @(posedge Clock); #1; Ten = 0; @(posedge Clock); #1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Insert 10 then 20 (Exact amount)", test_num);
        reset_dut();

        Ten = 1;    @(posedge Clock); #1; Ten = 0;    @(posedge Clock); #1;
        Twenty = 1; @(posedge Clock); #1; Twenty = 0; @(posedge Clock); #1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Insert 20 then 10 (Exact amount)", test_num);
        reset_dut();

        Twenty = 1; @(posedge Clock); #1; Twenty = 0; @(posedge Clock); #1;
        Ten = 1;    @(posedge Clock); #1; Ten = 0;    @(posedge Clock); #1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Insert 20, 20 (Change required)", test_num);
        reset_dut();

        Twenty = 1; @(posedge Clock); #1; Twenty = 0; @(posedge Clock); #1;
        Twenty = 1; @(posedge Clock); #1; Twenty = 0; @(posedge Clock); #1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Partial payment then Clear", test_num);
        reset_dut();

        Ten = 1; @(posedge Clock); #1; Ten = 0; @(posedge Clock); #1;


        Clear = 1; @(posedge Clock); #1; Clear = 0; @(posedge Clock); #1;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_Bill;
        input expected_Dispense;
        input expected_Ready;
        input expected_Return;
        begin
            if (expected_Bill === (expected_Bill ^ Bill ^ expected_Bill) &&
                expected_Dispense === (expected_Dispense ^ Dispense ^ expected_Dispense) &&
                expected_Ready === (expected_Ready ^ Ready ^ expected_Ready) &&
                expected_Return === (expected_Return ^ Return ^ expected_Return)) begin
                $display("PASS");
                $display("  Outputs: Bill=%b, Dispense=%b, Ready=%b, Return=%b",
                         Bill, Dispense, Ready, Return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bill=%b, Dispense=%b, Ready=%b, Return=%b",
                         expected_Bill, expected_Dispense, expected_Ready, expected_Return);
                $display("  Got:      Bill=%b, Dispense=%b, Ready=%b, Return=%b",
                         Bill, Dispense, Ready, Return);
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
        $dumpvars(0,Clear, Clock, Ten, Twenty, Bill, Dispense, Ready, Return);
    end

endmodule
