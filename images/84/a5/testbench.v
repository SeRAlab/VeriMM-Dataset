`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    wire [5:0] Address;
    wire [7:0] Data;
    wire RWB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .start(start),
        .Address(Address),
        .Data(Data),
        .RWB(RWB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle State Check (start=0)", test_num);
            reset_dut();
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Assert Start - Initialization Cycle", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(6'h01, 8'h20, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Bitwise Operations Check (Cycle 2)", test_num);
            reset_dut();
            start = 1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(6'h02, 8'h3F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: RWB Logic Check (Data[5] dependence)", test_num);
            reset_dut();
            start = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h03, 8'h0F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Stop Transition Check", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h00, 8'h00, 1'b0);
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
        input [5:0] expected_Address;
        input [7:0] expected_Data;
        input expected_RWB;
        begin
            if (expected_Address === (expected_Address ^ Address ^ expected_Address) &&
                expected_Data === (expected_Data ^ Data ^ expected_Data) &&
                expected_RWB === (expected_RWB ^ RWB ^ expected_RWB)) begin
                $display("PASS");
                $display("  Outputs: Address=%h, Data=%h, RWB=%b",
                         Address, Data, RWB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Address=%h, Data=%h, RWB=%b",
                         expected_Address, expected_Data, expected_RWB);
                $display("  Got:      Address=%h, Data=%h, RWB=%b",
                         Address, Data, RWB);
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
        $dumpvars(0,clk, start, Address, Data, RWB);
    end

endmodule
