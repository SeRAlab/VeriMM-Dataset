`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control_in;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control_in(control_in),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Control 00 (Unchanged) - Input 8'hA5", test_num);
        control_in = 2'b00;
        data_in = 8'hA5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Control 00 (Unchanged) - Input 8'h5A", test_num);
        control_in = 2'b00;
        data_in = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Control 01 (NOT) - Input 8'hAA", test_num);
        control_in = 2'b01;
        data_in = 8'hAA;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Control 01 (NOT) - Input 8'h00", test_num);
        control_in = 2'b01;
        data_in = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Control 10 (Left Shift) - Input 8'h01", test_num);
        control_in = 2'b10;
        data_in = 8'h01;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Control 10 (Left Shift) - Input 8'h80", test_num);
        control_in = 2'b10;
        data_in = 8'h80;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Control 10 (Left Shift) - Input 8'hFF", test_num);
        control_in = 2'b10;
        data_in = 8'hFF;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Control 11 (Right Shift) - Input 8'h80", test_num);
        control_in = 2'b11;
        data_in = 8'h80;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Control 11 (Right Shift) - Input 8'h01", test_num);
        control_in = 2'b11;
        data_in = 8'h01;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Control 11 (Right Shift) - Input 8'hAA", test_num);
        control_in = 2'b11;
        data_in = 8'hAA;
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
