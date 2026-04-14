`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address_in;
    wire [7:0] address_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_in(address_in),
        .address_out(address_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Minimum Value (0x00)", test_num);
            address_in = 8'h00;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Lower Nibble Carry (0x0F)", test_num);
            address_in = 8'h0F;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Mid-range Boundary (0x7F)", test_num);
            address_in = 8'h7F;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Upper Bound (0xFE)", test_num);
            address_in = 8'hFE;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Maximum Value Wrap-around (0xFF)", test_num);
            address_in = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Alternating Bit Pattern 1 (0x55)", test_num);
            address_in = 8'h55;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Alternating Bit Pattern 2 (0xAA)", test_num);
            address_in = 8'hAA;
            #1;

            check_outputs(8'hAB);
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
        input [7:0] expected_address_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address_out === (expected_address_out ^ address_out ^ expected_address_out)) begin
                $display("PASS");
                $display("  Outputs: address_out=%h",
                         address_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_out=%h",
                         expected_address_out);
                $display("  Got:      address_out=%h",
                         address_out);
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

endmodule
