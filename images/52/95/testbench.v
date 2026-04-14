`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [4:0] BCD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .BCD(BCD)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        bin = 4'd0;
        $display("Test Case %0d: Input bin = 0", test_num);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        bin = 4'd5;
        $display("Test Case %0d: Input bin = 5", test_num);
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        bin = 4'd9;
        $display("Test Case %0d: Input bin = 9", test_num);
        #1;

        check_outputs(5'h09);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        bin = 4'd10;
        $display("Test Case %0d: Input bin = 10 (Boundary)", test_num);
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        bin = 4'd11;
        $display("Test Case %0d: Input bin = 11", test_num);
        #1;

        check_outputs(5'h11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        bin = 4'd12;
        $display("Test Case %0d: Input bin = 12", test_num);
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        bin = 4'd13;
        $display("Test Case %0d: Input bin = 13", test_num);
        #1;

        check_outputs(5'h13);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        bin = 4'd14;
        $display("Test Case %0d: Input bin = 14", test_num);
        #1;

        check_outputs(5'h14);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        bin = 4'd15;
        $display("Test Case %0d: Input bin = 15 (Max)", test_num);
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        bin = 4'd8;
        $display("Test Case %0d: Input bin = 8", test_num);
        #1;

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
        input [4:0] expected_BCD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BCD === (expected_BCD ^ BCD ^ expected_BCD)) begin
                $display("PASS");
                $display("  Outputs: BCD=%h",
                         BCD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD=%h",
                         expected_BCD);
                $display("  Got:      BCD=%h",
                         BCD);
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
