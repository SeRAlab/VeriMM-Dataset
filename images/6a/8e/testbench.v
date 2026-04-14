`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] input0;
    reg [4:0] input1;
    reg [4:0] input2;
    reg [4:0] input3;
    reg [1:0] select;
    wire [4:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input0(input0),
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .select(select),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = 1;
            input0 = 5'b10101;
            input1 = 5'b00000;
            input2 = 5'b11111;
            input3 = 5'b01010;
            select = 2'b00;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input0 = 5'b10101;
            input1 = 5'b01100;
            input2 = 5'b11111;
            input3 = 5'b01010;
            select = 2'b01;
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input0 = 5'b10101;
            input1 = 5'b01100;
            input2 = 5'b10001;
            input3 = 5'b01010;
            select = 2'b10;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input0 = 5'b10101;
            input1 = 5'b01100;
            input2 = 5'b10001;
            input3 = 5'b11110;
            select = 2'b11;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            input0 = 5'b11111;
            input1 = 5'b11111;
            input2 = 5'b11111;
            input3 = 5'b11111;
            select = 2'b10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            input0 = 5'b00000;
            input1 = 5'b00000;
            input2 = 5'b00000;
            input3 = 5'b00000;
            select = 2'b00;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            input0 = 5'h01;
            input1 = 5'h02;
            input2 = 5'h04;
            input3 = 5'h08;

            select = 2'b00; #1;
 check_outputs(5'h01);
            select = 2'b01; #1;
 check_outputs(5'h02);
            select = 2'b10; #1;
 check_outputs(5'h04);
            select = 2'b11; #1;
 check_outputs(5'h08);
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
        input [4:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
