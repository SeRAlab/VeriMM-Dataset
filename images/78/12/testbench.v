`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BCD;
    wire [6:0] SEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCD(BCD),
        .SEG(SEG)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        BCD = 4'd0;
        $display("Test %0d: BCD = 0", test_num);
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        BCD = 4'd1;
        $display("Test %0d: BCD = 1", test_num);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        BCD = 4'd2;
        $display("Test %0d: BCD = 2", test_num);
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        BCD = 4'd3;
        $display("Test %0d: BCD = 3", test_num);
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        BCD = 4'd4;
        $display("Test %0d: BCD = 4", test_num);
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        BCD = 4'd5;
        $display("Test %0d: BCD = 5", test_num);
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        BCD = 4'd6;
        $display("Test %0d: BCD = 6", test_num);
        #1;

        check_outputs(7'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        BCD = 4'd7;
        $display("Test %0d: BCD = 7", test_num);
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        BCD = 4'd8;
        $display("Test %0d: BCD = 8", test_num);
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        BCD = 4'd9;
        $display("Test %0d: BCD = 9", test_num);
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        BCD = 4'd10;
        $display("Test %0d: BCD = 10 (Invalid)", test_num);
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        BCD = 4'd15;
        $display("Test %0d: BCD = 15 (Invalid)", test_num);
        #1;

        check_outputs(7'h00);
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
        testcase011();
        testcase012();
        
        
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
        input [6:0] expected_SEG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SEG === (expected_SEG ^ SEG ^ expected_SEG)) begin
                $display("PASS");
                $display("  Outputs: SEG=%h",
                         SEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEG=%h",
                         expected_SEG);
                $display("  Got:      SEG=%h",
                         SEG);
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
