`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in_num;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] out_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_num(in_num),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out_num(out_num)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing input 3'b000", test_num);
        in_num = 3'b000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing input 3'b001", test_num);
        in_num = 3'b001;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing input 3'b010", test_num);
        in_num = 3'b010;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing input 3'b011", test_num);
        in_num = 3'b011;
        #1;

        check_outputs(1'b1, 1'b1, 1'b0, 3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing input 3'b100", test_num);
        in_num = 3'b100;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing input 3'b101", test_num);
        in_num = 3'b101;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1, 3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing input 3'b110", test_num);
        in_num = 3'b110;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1, 3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing input 3'b111", test_num);
        in_num = 3'b111;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1, 3'b111);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_out_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out_num === (expected_out_num ^ out_num ^ expected_out_num)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, out_num=%h",
                         o0, o1, o2, out_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, out_num=%h",
                         expected_o0, expected_o1, expected_o2, expected_out_num);
                $display("  Got:      o0=%b, o1=%b, o2=%b, out_num=%h",
                         o0, o1, o2, out_num);
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
