`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCWre;
    reg Reset;
    reg clk;
    reg [31:0] nextAddress;
    wire [31:0] Address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCWre(PCWre),
        .Reset(Reset),
        .clk(clk),
        .nextAddress(nextAddress),
        .Address(Address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Reset = 0;
            PCWre = 0;
            nextAddress = 0;
            @(posedge clk);
            #1 Reset = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Power-on Reset logic", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Load Next Address (PCWre=1)", test_num);
            reset_dut();
            PCWre = 1;
            nextAddress = 32'h0000_1000;
            @(posedge clk);
            #1;

            check_outputs(32'h0000_1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Disable Load (PCWre=0)", test_num);
            reset_dut();

            PCWre = 1;
            nextAddress = 32'hAAAA_BBBB;
            @(posedge clk);

            #1 PCWre = 0;
            nextAddress = 32'h5555_6666;
            @(posedge clk);
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sequential Address Updates", test_num);
            reset_dut();
            PCWre = 1;

            nextAddress = 32'h0000_0004;
            @(posedge clk);
            #1 nextAddress = 32'h0000_0008;
            @(posedge clk);
            #1 nextAddress = 32'h0000_000C;
            @(posedge clk);

            #1;


            check_outputs(32'h0000_000C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Load Max 32-bit Value", test_num);
            reset_dut();
            PCWre = 1;
            nextAddress = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Synchronous Reset override", test_num);
            reset_dut();
            PCWre = 1;
            nextAddress = 32'h1234_5678;
            @(posedge clk);

            #1 Reset = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_Address;
        begin
            if (expected_Address === (expected_Address ^ Address ^ expected_Address)) begin
                $display("PASS");
                $display("  Outputs: Address=%h",
                         Address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Address=%h",
                         expected_Address);
                $display("  Got:      Address=%h",
                         Address);
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
        $dumpvars(0,PCWre, Reset, clk, nextAddress, Address);
    end

endmodule
