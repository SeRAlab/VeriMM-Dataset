`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in_A;
    reg [15:0] data_in_B;
    reg [5:0] instruction;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in_A(data_in_A),
        .data_in_B(data_in_B),
        .instruction(instruction),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: MOVE A to Output", test_num);
        instruction = OP_MOVE;
        data_in_A = 16'hA5A5;
        data_in_B = 16'h0000;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: NOT A", test_num);
        instruction = OP_NOT;
        data_in_A = 16'hF0F0;
        data_in_B = 16'h0000;
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Bitwise AND", test_num);
        instruction = OP_AND;
        data_in_A = 16'hFF00;
        data_in_B = 16'hAAAA;
        #1;

        check_outputs(16'hAA00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Bitwise OR", test_num);
        instruction = OP_OR;
        data_in_A = 16'h1234;
        data_in_B = 16'h8888;
        #1;

        check_outputs(16'h9ABC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: SHIFTL (A << 1)", test_num);
        instruction = OP_SHIFTL;
        data_in_A = 16'h0001;
        data_in_B = 16'h0001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: SHIFTR (A >> 1)", test_num);
        instruction = OP_SHIFTR;
        data_in_A = 16'h8000;
        data_in_B = 16'h0001;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: ADD (Simple)", test_num);
        instruction = OP_ADD;
        data_in_A = 16'd1000;
        data_in_B = 16'd250;
        #1;

        check_outputs(16'd1250);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: ADD (Wrap-around)", test_num);
        instruction = OP_ADD;
        data_in_A = 16'hFFFF;
        data_in_B = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: SUB (Simple)", test_num);
        instruction = OP_SUB;
        data_in_A = 16'd500;
        data_in_B = 16'd100;
        #1;

        check_outputs(16'd400);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: SUB (Wrap-around)", test_num);
        instruction = OP_SUB;
        data_in_A = 16'h0000;
        data_in_B = 16'h0001;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_data_out;
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
