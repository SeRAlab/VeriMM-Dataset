`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a_in;
    wire [7:0] s_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .s_out(s_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input 0", test_num);
        a_in = 4'd0;
        #1;

        check_outputs(8'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input 1", test_num);
        a_in = 4'd1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input 2", test_num);
        a_in = 4'd2;
        #1;

        check_outputs(8'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input 3", test_num);
        a_in = 4'd3;
        #1;

        check_outputs(8'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input 4", test_num);
        a_in = 4'd4;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input 5", test_num);
        a_in = 4'd5;
        #1;

        check_outputs(8'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input 6", test_num);
        a_in = 4'd6;
        #1;

        check_outputs(8'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Input 7", test_num);
        a_in = 4'd7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Input 8", test_num);
        a_in = 4'd8;
        #1;

        check_outputs(8'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Input 9", test_num);
        a_in = 4'd9;
        #1;

        check_outputs(8'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Input 10 (Should be off)", test_num);
        a_in = 4'd10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Input 15 (Should be off)", test_num);
        a_in = 4'd15;
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
        input [7:0] expected_s_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s_out === (expected_s_out ^ s_out ^ expected_s_out)) begin
                $display("PASS");
                $display("  Outputs: s_out=%h",
                         s_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_out=%h",
                         expected_s_out);
                $display("  Got:      s_out=%h",
                         s_out);
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
