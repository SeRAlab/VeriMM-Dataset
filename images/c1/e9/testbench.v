`timescale 1ns/1ps

module bcd7seg_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bcd7seg dut (
        .bcd(bcd),
        .seg(seg)
    );
    task testcase001;

    begin
        $display("Test Case 001: BCD 0");
        test_num = 1;
        bcd = 4'd0;
        #1;

        check_outputs(7'b1000000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: BCD 1");
        test_num = 2;
        bcd = 4'd1;
        #1;

        check_outputs(7'b1111001);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: BCD 2");
        test_num = 3;
        bcd = 4'd2;
        #1;

        check_outputs(7'b0100100);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: BCD 3");
        test_num = 4;
        bcd = 4'd3;
        #1;

        check_outputs(7'b0110000);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: BCD 4");
        test_num = 5;
        bcd = 4'd4;
        #1;

        check_outputs(7'b0011001);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: BCD 5");
        test_num = 6;
        bcd = 4'd5;
        #1;

        check_outputs(7'b0010010);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: BCD 6");
        test_num = 7;
        bcd = 4'd6;
        #1;

        check_outputs(7'b0000010);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: BCD 7");
        test_num = 8;
        bcd = 4'd7;
        #1;

        check_outputs(7'b1111000);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: BCD 8");
        test_num = 9;
        bcd = 4'd8;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: BCD 9");
        test_num = 10;
        bcd = 4'd9;
        #1;

        check_outputs(7'b0011000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bcd7seg Testbench");
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
