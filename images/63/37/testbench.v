`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    reg [1:0] select;
    wire [7:0] out0;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .select(select),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select 00, Input 0xAA", test_num);
            in = 8'hAA;
            select = 2'b00;
            #1;

            check_outputs(8'hAA, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select 01, Input 0x55", test_num);
            in = 8'h55;
            select = 2'b01;
            #1;

            check_outputs(8'h00, 8'h55, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select 10, Input 0xFF", test_num);
            in = 8'hFF;
            select = 2'b10;
            #1;

            check_outputs(8'h00, 8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select 11, Input 0x0F", test_num);
            in = 8'h0F;
            select = 2'b11;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select 00, Input 0x00 (All Zeros Check)", test_num);
            in = 8'h00;
            select = 2'b00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select 10, Input 0x12 (Arbitrary Value)", test_num);
            in = 8'h12;
            select = 2'b10;
            #1;

            check_outputs(8'h00, 8'h00, 8'h12, 8'h00);
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
        input [7:0] expected_out0;
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
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
