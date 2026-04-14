`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_data1;
    reg [3:0] in_data2;
    wire cy;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_data1(in_data1),
        .in_data2(in_data2),
        .cy(cy),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Adding zeros", test_num);
        in_data1 = 4'd0;
        in_data2 = 4'd0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: 5 + 3 = 8", test_num);
        in_data1 = 4'd5;
        in_data2 = 4'd3;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: 7 + 8 = 15", test_num);
        in_data1 = 4'd7;
        in_data2 = 4'd8;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: 15 + 1 = 16 (Carry Out)", test_num);
        in_data1 = 4'd15;
        in_data2 = 4'd1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: 15 + 15 = 30 (Carry Out)", test_num);
        in_data1 = 4'd15;
        in_data2 = 4'd15;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: 10 + 10 = 20 (Carry Out)", test_num);
        in_data1 = 4'd10;
        in_data2 = 4'd10;
        #1;

        check_outputs(1'b1, 4'd4);
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
        input expected_cy;
        input [3:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cy === (expected_cy ^ cy ^ expected_cy) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: cy=%b, out_data=%h",
                         cy, out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cy=%b, out_data=%h",
                         expected_cy, expected_out_data);
                $display("  Got:      cy=%b, out_data=%h",
                         cy, out_data);
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
