`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [5:0] shift_amount;
    wire [63:0] left;
    wire [63:0] right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .shift_amount(shift_amount),
        .left(left),
        .right(right)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Shift (Identity)", test_num);
        A = 64'hFEDCBA9876543210;
        shift_amount = 6'd0;
        #1;

        check_outputs(64'hFEDCBA9876543210, 64'hFEDCBA9876543210);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small Shift (1 bit)", test_num);
        A = 64'h0000000000000001;
        shift_amount = 6'd1;
        #1;

        check_outputs(64'h0000000000000002, 64'h0000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Halfway (32 bits)", test_num);
        A = 64'hFFFFFFFF00000000;
        shift_amount = 6'd32;
        #1;

        check_outputs(64'h0000000000000000, 64'h00000000FFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Shift (63 bits)", test_num);
        A = 64'h8000000000000001;
        shift_amount = 6'd63;
        #1;

        check_outputs(64'h8000000000000000, 64'h0000000000000001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones, shift by 4", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        shift_amount = 6'd4;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFF0, 64'h0FFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern, shift by 8", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        shift_amount = 6'd8;
        #1;

        check_outputs(64'hAAAAAAAAAAAAAAAA00, 64'h00AAAAAAAAAAAAAAAA);


        #1;



        check_outputs(64'hAAAAAAAAAAAAAAAA << 8, 64'hAAAAAAAAAAAAAAAA >> 8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case - shift single MSB bit off", test_num);
        A = 64'h8000000000000000;
        shift_amount = 6'd1;
        #1;

        check_outputs(64'h0000000000000000, 64'h4000000000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case - shift single LSB bit off", test_num);
        A = 64'h0000000000000001;
        shift_amount = 6'd1;
        #1;

        check_outputs(64'h0000000000000002, 64'h0000000000000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random data, shift by 16", test_num);
        A = 64'h1234567812345678;
        shift_amount = 6'd16;
        #1;

        check_outputs(64'h5678123456780000, 64'h0000123456781234);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High shift amount, small value", test_num);
        A = 64'h00000000000000FF;
        shift_amount = 6'd60;
        #1;

        check_outputs(64'hF000000000000000, 64'h0000000000000000);
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
        input [63:0] expected_left;
        input [63:0] expected_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_left === (expected_left ^ left ^ expected_left) &&
                expected_right === (expected_right ^ right ^ expected_right)) begin
                $display("PASS");
                $display("  Outputs: left=%h, right=%h",
                         left, right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left=%h, right=%h",
                         expected_left, expected_right);
                $display("  Got:      left=%h, right=%h",
                         left, right);
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
