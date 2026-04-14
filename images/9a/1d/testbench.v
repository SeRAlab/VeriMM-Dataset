`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sw;
    wire dis;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sw(sw),
        .dis(dis),
        .seg(seg)
    );
    task testcase001;

    begin
        $display("Test Case 001: sw = 0 (Digit 0)");
        sw = 4'h0;
        #1;

        check_outputs(1'b0, 7'h40);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: sw = 1 (Digit 1)");
        sw = 4'h1;
        #1;

        check_outputs(1'b0, 7'h79);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: sw = 2 (Digit 2)");
        sw = 4'h2;
        #1;

        check_outputs(1'b0, 7'h24);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: sw = 3 (Digit 3)");
        sw = 4'h3;
        #1;

        check_outputs(1'b0, 7'h30);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: sw = 4 (Digit 4)");
        sw = 4'h4;
        #1;

        check_outputs(1'b0, 7'h19);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: sw = 5 (Digit 5)");
        sw = 4'h5;
        #1;

        check_outputs(1'b0, 7'h12);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: sw = 6 (Digit 6)");
        sw = 4'h6;
        #1;

        check_outputs(1'b0, 7'h02);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: sw = 7 (Digit 7)");
        sw = 4'h7;
        #1;

        check_outputs(1'b0, 7'h78);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: sw = 8 (Digit 8)");
        sw = 4'h8;
        #1;

        check_outputs(1'b0, 7'h00);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: sw = 9 (Digit 9)");
        sw = 4'h9;
        #1;

        check_outputs(1'b0, 7'h10);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: sw = A (Digit A)");
        sw = 4'hA;
        #1;

        check_outputs(1'b0, 7'h08);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: sw = B (Digit b)");
        sw = 4'hB;
        #1;

        check_outputs(1'b0, 7'h03);
    end
        endtask

    task testcase013;

    begin
        $display("Test Case 013: sw = C (Digit C)");
        sw = 4'hC;
        #1;

        check_outputs(1'b0, 7'h46);
    end
        endtask

    task testcase014;

    begin
        $display("Test Case 014: sw = D (Digit d)");
        sw = 4'hD;
        #1;

        check_outputs(1'b0, 7'h21);
    end
        endtask

    task testcase015;

    begin
        $display("Test Case 015: sw = E (Digit E)");
        sw = 4'hE;
        #1;

        check_outputs(1'b0, 7'h06);
    end
        endtask

    task testcase016;

    begin
        $display("Test Case 016: sw = F (Digit F)");
        sw = 4'hF;
        #1;

        check_outputs(1'b0, 7'h0E);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_dis;
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dis === (expected_dis ^ dis ^ expected_dis) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: dis=%b, seg=%h",
                         dis, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dis=%b, seg=%h",
                         expected_dis, expected_seg);
                $display("  Got:      dis=%b, seg=%h",
                         dis, seg);
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
