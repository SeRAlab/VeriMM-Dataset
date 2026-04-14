`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] intrinsic_info;
    reg [7:0] msg_from_check0;
    reg [7:0] msg_from_check1;
    reg [7:0] msg_from_check2;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .intrinsic_info(intrinsic_info),
        .msg_from_check0(msg_from_check0),
        .msg_from_check1(msg_from_check1),
        .msg_from_check2(msg_from_check2),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Sum (All zeros)", test_num);
        intrinsic_info   = 8'd0;
        msg_from_check0  = 8'd0;
        msg_from_check1  = 8'd0;
        msg_from_check2  = 8'd0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small Positive Sum", test_num);
        intrinsic_info   = 8'd1;
        msg_from_check0  = 8'd2;
        msg_from_check1  = 8'd3;
        msg_from_check2  = 8'd4;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Negative Sum", test_num);
        intrinsic_info   = -8'd5;
        msg_from_check0  = -8'd10;
        msg_from_check1  = 8'd2;
        msg_from_check2  = 8'd3;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Sum (Cancellation)", test_num);
        intrinsic_info   = 8'd50;
        msg_from_check0  = -8'd50;
        msg_from_check1  = 8'd25;
        msg_from_check2  = -8'd25;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max 8-bit Positive Sum (127)", test_num);
        intrinsic_info   = 8'd60;
        msg_from_check0  = 8'd40;
        msg_from_check1  = 8'd20;
        msg_from_check2  = 8'd7;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Min 8-bit Negative Sum (-128)", test_num);
        intrinsic_info   = -8'd64;
        msg_from_check0  = -8'd64;
        msg_from_check1  = 8'd0;
        msg_from_check2  = 8'd0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 8-bit Positive Overflow (Wraps to Negative)", test_num);
        intrinsic_info   = 8'd80;
        msg_from_check0  = 8'd50;
        msg_from_check1  = 8'd0;
        msg_from_check2  = 8'd0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 8-bit Negative Underflow (Wraps to Positive)", test_num);
        intrinsic_info   = -8'd100;
        msg_from_check0  = -8'd50;
        msg_from_check1  = 8'd0;
        msg_from_check2  = 8'd0;

        #1;


        check_outputs(1'b1);
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
        input expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
