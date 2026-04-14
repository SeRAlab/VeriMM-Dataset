`timescale 1ns/1ps

module bcd_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bcd_to_7seg dut (
        .bcd(bcd),
        .seg(seg)
    );
    task testcase001;

    begin
        test_num = 1;
        bcd = 4'd0;
        $display("Test Case 001: BCD = 0");
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bcd = 4'd1;
        $display("Test Case 002: BCD = 1");
        #1;

        check_outputs(7'b0000110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bcd = 4'd2;
        $display("Test Case 003: BCD = 2");
        #1;

        check_outputs(7'b1011011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bcd = 4'd3;
        $display("Test Case 004: BCD = 3");
        #1;

        check_outputs(7'b1001111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bcd = 4'd4;
        $display("Test Case 005: BCD = 4");
        #1;

        check_outputs(7'b1100110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bcd = 4'd5;
        $display("Test Case 006: BCD = 5");
        #1;

        check_outputs(7'b1101101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bcd = 4'd6;
        $display("Test Case 007: BCD = 6");
        #1;

        check_outputs(7'b1111101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bcd = 4'd7;
        $display("Test Case 008: BCD = 7");
        #1;

        check_outputs(7'b0000111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bcd = 4'd8;
        $display("Test Case 009: BCD = 8");
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bcd = 4'd9;
        $display("Test Case 010: BCD = 9");
        #1;

        check_outputs(7'b1101111);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        bcd = 4'd15;
        $display("Test Case 011: BCD = 15 (Invalid)");
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bcd_to_7seg Testbench");
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
