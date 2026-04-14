`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [6:0] seven_seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .seven_seg(seven_seg)
    );
    task testcase000;

    begin
        test_num = 0;
        bcd = 4'd0;
        $display("Test %0d: BCD Input 0", test_num);
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        bcd = 4'd1;
        $display("Test %0d: BCD Input 1", test_num);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bcd = 4'd2;
        $display("Test %0d: BCD Input 2", test_num);
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bcd = 4'd3;
        $display("Test %0d: BCD Input 3", test_num);
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bcd = 4'd4;
        $display("Test %0d: BCD Input 4", test_num);
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bcd = 4'd5;
        $display("Test %0d: BCD Input 5", test_num);
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bcd = 4'd6;
        $display("Test %0d: BCD Input 6", test_num);
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bcd = 4'd7;
        $display("Test %0d: BCD Input 7", test_num);
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bcd = 4'd8;
        $display("Test %0d: BCD Input 8", test_num);
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bcd = 4'd9;
        $display("Test %0d: BCD Input 9", test_num);
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bcd = 4'd10;
        $display("Test %0d: Invalid BCD Input 10", test_num);
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        bcd = 4'd15;
        $display("Test %0d: Invalid BCD Input 15", test_num);
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
        input [6:0] expected_seven_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seven_seg === (expected_seven_seg ^ seven_seg ^ expected_seven_seg)) begin
                $display("PASS");
                $display("  Outputs: seven_seg=%h",
                         seven_seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_seg=%h",
                         expected_seven_seg);
                $display("  Got:      seven_seg=%h",
                         seven_seg);
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
