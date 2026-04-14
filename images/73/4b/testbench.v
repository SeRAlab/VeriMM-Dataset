`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd_data;
    wire [7:0] seg_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_data(bcd_data),
        .seg_data(seg_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input BCD = 0", test_num);
        bcd_data = 4'd0;
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input BCD = 1", test_num);
        bcd_data = 4'd1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input BCD = 2", test_num);
        bcd_data = 4'd2;
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input BCD = 3", test_num);
        bcd_data = 4'd3;
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input BCD = 4", test_num);
        bcd_data = 4'd4;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input BCD = 5", test_num);
        bcd_data = 4'd5;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input BCD = 6", test_num);
        bcd_data = 4'd6;
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input BCD = 7", test_num);
        bcd_data = 4'd7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input BCD = 8", test_num);
        bcd_data = 4'd8;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input BCD = 9", test_num);
        bcd_data = 4'd9;
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Input BCD = 10 (Invalid)", test_num);
        bcd_data = 4'd10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Input BCD = 15 (Invalid)", test_num);
        bcd_data = 4'd15;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_seg_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_data === (expected_seg_data ^ seg_data ^ expected_seg_data)) begin
                $display("PASS");
                $display("  Outputs: seg_data=%h",
                         seg_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_data=%h",
                         expected_seg_data);
                $display("  Got:      seg_data=%h",
                         seg_data);
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
