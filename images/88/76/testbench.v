`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] rx;
    reg [7:0] ry;
    wire [7:0] adder_out;
    wire [7:0] and_out;
    wire [7:0] is_zero_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx(rx),
        .ry(ry),
        .adder_out(adder_out),
        .and_out(and_out),
        .is_zero_out(is_zero_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0, ry=0 (Zero Case)", test_num);
        rx = 8'h00;
        ry = 8'h00;



        #1;




        check_outputs(8'h00, 8'h00, 8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0x55, ry=0xAA (Alternating Bits)", test_num);
        rx = 8'h55;
        ry = 8'hAA;



        #1;




        check_outputs(8'hFF, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0xFF, ry=0x01 (Overflow Sum)", test_num);
        rx = 8'hFF;
        ry = 8'h01;



        #1;




        check_outputs(8'h00, 8'h01, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0x00, ry=0xFF (Zero Indicator Check)", test_num);
        rx = 8'h00;
        ry = 8'hFF;



        #1;




        check_outputs(8'hFF, 8'h00, 8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0x0F, ry=0xF0 (Bitwise Disjoint)", test_num);
        rx = 8'h0F;
        ry = 8'hF0;



        #1;




        check_outputs(8'hFF, 8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0x12, ry=0x34 (General Operation)", test_num);
        rx = 8'h12;
        ry = 8'h34;



        #1;




        check_outputs(8'h46, 8'h10, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: rx=0xFF, ry=0xFF (Full Bits)", test_num);
        rx = 8'hFF;
        ry = 8'hFF;



        #1;




        check_outputs(8'hFE, 8'hFF, 8'h00);
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
        input [7:0] expected_adder_out;
        input [7:0] expected_and_out;
        input [7:0] expected_is_zero_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out) &&
                expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_is_zero_out === (expected_is_zero_out ^ is_zero_out ^ expected_is_zero_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h, and_out=%h, is_zero_out=%h",
                         adder_out, and_out, is_zero_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h, and_out=%h, is_zero_out=%h",
                         expected_adder_out, expected_and_out, expected_is_zero_out);
                $display("  Got:      adder_out=%h, and_out=%h, is_zero_out=%h",
                         adder_out, and_out, is_zero_out);
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
