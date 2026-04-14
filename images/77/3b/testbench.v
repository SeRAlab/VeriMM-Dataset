`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase000;

    begin
        test_num = 0;
        in = 4'd0;
        $display("Test Case %0d: Input 0", test_num);
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        in = 4'd1;
        $display("Test Case %0d: Input 1", test_num);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 4'd2;
        $display("Test Case %0d: Input 2", test_num);
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 4'd3;
        $display("Test Case %0d: Input 3", test_num);
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 4'd4;
        $display("Test Case %0d: Input 4", test_num);
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 4'd5;
        $display("Test Case %0d: Input 5", test_num);
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 4'd6;
        $display("Test Case %0d: Input 6", test_num);
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 4'd7;
        $display("Test Case %0d: Input 7", test_num);
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 4'd8;
        $display("Test Case %0d: Input 8", test_num);
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 4'd9;
        $display("Test Case %0d: Input 9", test_num);
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 4'd10;
        $display("Test Case %0d: Input 10 (A)", test_num);
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 4'd11;
        $display("Test Case %0d: Input 11 (b)", test_num);
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in = 4'd12;
        $display("Test Case %0d: Input 12 (C)", test_num);
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        in = 4'd13;
        $display("Test Case %0d: Input 13 (d)", test_num);
        #1;

        check_outputs(7'h5e);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        in = 4'd14;
        $display("Test Case %0d: Input 14 (E)", test_num);
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        in = 4'd15;
        $display("Test Case %0d: Input 15 (F)", test_num);
        #1;

        check_outputs(7'h71);
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [6:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
