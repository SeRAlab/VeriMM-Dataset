`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] SW;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .seg(seg)
    );
    task testcase001;

    begin
        SW = 4'h0;
        #10;
        $display("Test Case 001: Input 0");
        #1;

        check_outputs(7'b1000000);
    end
        endtask

    task testcase002;

    begin
        SW = 4'h1;
        #10;
        $display("Test Case 002: Input 1");
        #1;

        check_outputs(7'b1111001);
    end
        endtask

    task testcase003;

    begin
        SW = 4'h2;
        #10;
        $display("Test Case 003: Input 2");
        #1;

        check_outputs(7'b0100100);
    end
        endtask

    task testcase004;

    begin
        SW = 4'h3;
        #10;
        $display("Test Case 004: Input 3");
        #1;

        check_outputs(7'b0110000);
    end
        endtask

    task testcase005;

    begin
        SW = 4'h4;
        #10;
        $display("Test Case 005: Input 4");
        #1;

        check_outputs(7'b0011001);
    end
        endtask

    task testcase006;

    begin
        SW = 4'h5;
        #10;
        $display("Test Case 006: Input 5");
        #1;

        check_outputs(7'b0010010);
    end
        endtask

    task testcase007;

    begin
        SW = 4'h6;
        #10;
        $display("Test Case 007: Input 6");
        #1;

        check_outputs(7'b0000010);
    end
        endtask

    task testcase008;

    begin
        SW = 4'h7;
        #10;
        $display("Test Case 008: Input 7");
        #1;

        check_outputs(7'b1111000);
    end
        endtask

    task testcase009;

    begin
        SW = 4'h8;
        #10;
        $display("Test Case 009: Input 8");
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase010;

    begin
        SW = 4'h9;
        #10;
        $display("Test Case 010: Input 9");
        #1;

        check_outputs(7'b0010000);
    end
        endtask

    task testcase011;

    begin
        SW = 4'hA;
        #10;
        $display("Test Case 011: Input A");
        #1;

        check_outputs(7'b0001000);
    end
        endtask

    task testcase012;

    begin
        SW = 4'hB;
        #10;
        $display("Test Case 012: Input B");
        #1;

        check_outputs(7'b0000011);
    end
        endtask

    task testcase013;

    begin
        SW = 4'hC;
        #10;
        $display("Test Case 013: Input C");
        #1;

        check_outputs(7'b1000110);
    end
        endtask

    task testcase014;

    begin
        SW = 4'hD;
        #10;
        $display("Test Case 014: Input D");
        #1;

        check_outputs(7'b0100001);
    end
        endtask

    task testcase015;

    begin
        SW = 4'hE;
        #10;
        $display("Test Case 015: Input E");
        #1;

        check_outputs(7'b0000110);
    end
        endtask

    task testcase016;

    begin
        SW = 4'hF;
        #10;
        $display("Test Case 016: Input F");
        #1;

        check_outputs(7'b0001110);
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
