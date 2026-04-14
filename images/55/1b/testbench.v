`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire [3:0] out_high;
    wire [3:0] out_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .out_high(out_high),
        .out_low(out_low)
    );
    task set_inputs;

        input iA, iB, iC, iD;
        begin
            A = iA; B = iB; C = iC; D = iD;
        end
        endtask

    task testcase000;

    begin
        test_num = 0;
        set_inputs(0, 0, 0, 0);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        set_inputs(0, 0, 0, 1);
        #1;

        check_outputs(4'd0, 4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        set_inputs(0, 0, 1, 0);
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        set_inputs(0, 0, 1, 1);
        #1;

        check_outputs(4'd0, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        set_inputs(0, 1, 0, 0);
        #1;

        check_outputs(4'd0, 4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        set_inputs(0, 1, 0, 1);
        #1;

        check_outputs(4'd0, 4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        set_inputs(0, 1, 1, 0);
        #1;

        check_outputs(4'd0, 4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        set_inputs(0, 1, 1, 1);
        #1;

        check_outputs(4'd0, 4'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        set_inputs(1, 0, 0, 0);
        #1;

        check_outputs(4'd0, 4'd8);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        set_inputs(1, 0, 0, 1);
        #1;

        check_outputs(4'd0, 4'd9);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        set_inputs(1, 0, 1, 0);
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        set_inputs(1, 0, 1, 1);
        #1;

        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        set_inputs(1, 1, 0, 0);
        #1;

        check_outputs(4'd1, 4'd2);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        set_inputs(1, 1, 0, 1);
        #1;

        check_outputs(4'd1, 4'd3);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        set_inputs(1, 1, 1, 0);
        #1;

        check_outputs(4'd1, 4'd4);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        set_inputs(1, 1, 1, 1);
        #1;

        check_outputs(4'd1, 4'd5);
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


        testcase000();
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [3:0] expected_out_high;
        input [3:0] expected_out_low;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_high === (expected_out_high ^ out_high ^ expected_out_high) &&
                expected_out_low === (expected_out_low ^ out_low ^ expected_out_low)) begin
                $display("PASS");
                $display("  Outputs: out_high=%h, out_low=%h",
                         out_high, out_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_high=%h, out_low=%h",
                         expected_out_high, expected_out_low);
                $display("  Got:      out_high=%h, out_low=%h",
                         out_high, out_low);
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
