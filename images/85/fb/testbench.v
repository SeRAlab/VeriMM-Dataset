`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] selector;
    reg [127:0] wide_input_bus;
    wire [7:0] selected_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .selector(selector),
        .wide_input_bus(wide_input_bus),
        .selected_out(selected_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select index 0 (LSB segment)", test_num);
        wide_input_bus = 128'h0;
        wide_input_bus[7:0] = 8'hA5;
        selector = 4'd0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select index 15 (MSB segment)", test_num);
        wide_input_bus = 128'h0;
        wide_input_bus[127:120] = 8'h5A;
        selector = 4'd15;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Verify unique values across segments (Index 7)", test_num);

        wide_input_bus = 128'h0F0E0D0C0B0A09080706050403020100;
        selector = 4'd7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Verify unique values across segments (Index 10)", test_num);
        wide_input_bus = 128'h0F0E0D0C0B0A09080706050403020100;
        selector = 4'd10;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All segments high except target", test_num);
        wide_input_bus = ~128'b0;
        wide_input_bus[47:40] = 8'h00;
        selector = 4'd5;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Checkerboard pattern", test_num);
        wide_input_bus = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        selector = 4'd2;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Inverse Checkerboard pattern", test_num);
        wide_input_bus = 128'h55555555555555555555555555555555;
        selector = 4'd13;
        #1;

        check_outputs(8'h55);
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
        input [7:0] expected_selected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_selected_out === (expected_selected_out ^ selected_out ^ expected_selected_out)) begin
                $display("PASS");
                $display("  Outputs: selected_out=%h",
                         selected_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected_out=%h",
                         expected_selected_out);
                $display("  Got:      selected_out=%h",
                         selected_out);
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
