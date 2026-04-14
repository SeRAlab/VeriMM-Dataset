`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input1;
    wire [4:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        input1 = 8'b00000000;
        $display("Test %0d: Input all zeros (00000000)", test_num);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input1 = 8'b11111111;
        $display("Test %0d: Input all ones (11111111)", test_num);
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input1 = 8'b00000001;
        $display("Test %0d: Single bit set (LSB)", test_num);
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input1 = 8'b10000000;
        $display("Test %0d: Single bit set (MSB)", test_num);
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input1 = 8'b10101010;
        $display("Test %0d: Alternating bits (10101010)", test_num);
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input1 = 8'b01010101;
        $display("Test %0d: Alternating bits (01010101)", test_num);
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        input1 = 8'b11110000;
        $display("Test %0d: Upper nibble ones (11110000)", test_num);
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        input1 = 8'b00001111;
        $display("Test %0d: Lower nibble ones (00001111)", test_num);
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        input1 = 8'b10111101;
        $display("Test %0d: Mixed bits (10111101)", test_num);
        #1;

        check_outputs(5'd6);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        input1 = 8'b01100110;
        $display("Test %0d: Mixed bits (01100110)", test_num);
        #1;

        check_outputs(5'd4);
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
        input [4:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
