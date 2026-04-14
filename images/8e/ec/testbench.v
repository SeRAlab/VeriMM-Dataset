`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] onehot;
    wire [3:0] bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .onehot(onehot),
        .bin(bin)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Bit 0", test_num);
        onehot = 16'h0001;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Bit 1", test_num);
        onehot = 16'h0002;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Bit 2", test_num);
        onehot = 16'h0004;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Bit 3", test_num);
        onehot = 16'h0008;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Bit 4", test_num);
        onehot = 16'h0010;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bit 7", test_num);
        onehot = 16'h0080;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Bit 8", test_num);
        onehot = 16'h0100;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Bit 10", test_num);
        onehot = 16'h0400;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Bit 14", test_num);
        onehot = 16'h4000;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Bit 15", test_num);
        onehot = 16'h8000;
        #1;

        check_outputs(4'd15);
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
        input [3:0] expected_bin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin === (expected_bin ^ bin ^ expected_bin)) begin
                $display("PASS");
                $display("  Outputs: bin=%h",
                         bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h",
                         expected_bin);
                $display("  Got:      bin=%h",
                         bin);
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
