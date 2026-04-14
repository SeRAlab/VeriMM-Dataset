`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [15:0] adder_input;
    reg [31:0] b;
    reg [1:0] operation_select;
    reg select;
    reg [4:0] shift_amount;
    wire [31:0] adder_result;
    wire [31:0] bitwise_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .adder_input(adder_input),
        .b(b),
        .operation_select(operation_select),
        .select(select),
        .shift_amount(shift_amount),
        .adder_result(adder_result),
        .bitwise_result(bitwise_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            a = 32'hF0F0F0F0;
            b = 32'hAAAAAAAA;
            operation_select = 2'b00;
            shift_amount = 5'd0;
            adder_input = 16'h0005;
            select = 1'b1;



            #1;




            check_outputs(32'hA0A0A0A5, 32'hA0A0A0A0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            a = 32'h12340000;
            b = 32'h00005678;
            operation_select = 2'b01;
            shift_amount = 5'd0;
            adder_input = 16'h1000;
            select = 1'b1;



            #1;




            check_outputs(32'h12346678, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h12345678;
            operation_select = 2'b10;
            shift_amount = 5'd0;
            adder_input = 16'h0001;
            select = 1'b1;



            #1;




            check_outputs(32'hEDCBA988, 32'hEDCBA987);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift", test_num);
            a = 32'h00000001;
            b = 32'hFFFFFFFF;
            operation_select = 2'b11;
            shift_amount = 5'd8;
            adder_input = 16'h00FF;
            select = 1'b1;



            #1;




            check_outputs(32'h000001FF, 32'h00000100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Bypass (select=0)", test_num);
            a = 32'h55555555;
            b = 32'h00000000;
            operation_select = 2'b00;
            shift_amount = 5'd0;
            adder_input = 16'h0000;
            select = 1'b0;



            #1;




            check_outputs(32'h55555555, 32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Left Shift", test_num);
            a = 32'h00000001;
            b = 32'h0;
            operation_select = 2'b11;
            shift_amount = 5'd31;
            adder_input = 16'h0000;
            select = 1'b1;



            #1;




            check_outputs(32'h80000000, 32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adder Carry-out", test_num);
            a = 32'h0000FFFF;
            b = 32'h00000000;
            operation_select = 2'b01;
            shift_amount = 5'd0;
            adder_input = 16'h0001;
            select = 1'b1;



            #1;




            check_outputs(32'h00010000, 32'h0000FFFF);
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
        input [31:0] expected_adder_result;
        input [31:0] expected_bitwise_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_result === (expected_adder_result ^ adder_result ^ expected_adder_result) &&
                expected_bitwise_result === (expected_bitwise_result ^ bitwise_result ^ expected_bitwise_result)) begin
                $display("PASS");
                $display("  Outputs: adder_result=%h, bitwise_result=%h",
                         adder_result, bitwise_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_result=%h, bitwise_result=%h",
                         expected_adder_result, expected_bitwise_result);
                $display("  Got:      adder_result=%h, bitwise_result=%h",
                         adder_result, bitwise_result);
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
