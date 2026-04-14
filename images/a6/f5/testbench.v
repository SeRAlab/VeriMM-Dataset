`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] digit;
    wire [7:0] encoding;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .digit(digit),
        .encoding(encoding)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input digit 0", test_num);
        digit = 4'h0;
        #1;

        check_outputs(8'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input digit 1", test_num);
        digit = 4'h1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input digit 2", test_num);
        digit = 4'h2;
        #1;

        check_outputs(8'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input digit 3", test_num);
        digit = 4'h3;
        #1;

        check_outputs(8'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input digit 4", test_num);
        digit = 4'h4;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input digit 5", test_num);
        digit = 4'h5;
        #1;

        check_outputs(8'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input digit 6", test_num);
        digit = 4'h6;
        #1;

        check_outputs(8'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input digit 7", test_num);
        digit = 4'h7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input digit 8", test_num);
        digit = 4'h8;
        #1;

        check_outputs(8'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input digit 9", test_num);
        digit = 4'h9;
        #1;

        check_outputs(8'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %0d: Invalid input digit 10 (A)", test_num);
        digit = 4'ha;
        #1;

        check_outputs(8'hff);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case %0d: Invalid input digit 11 (B)", test_num);
        digit = 4'hb;
        #1;

        check_outputs(8'hff);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case %0d: Invalid input digit 12 (C)", test_num);
        digit = 4'hc;
        #1;

        check_outputs(8'hff);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case %0d: Invalid input digit 13 (D)", test_num);
        digit = 4'hd;
        #1;

        check_outputs(8'hff);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case %0d: Invalid input digit 14 (E)", test_num);
        digit = 4'he;
        #1;

        check_outputs(8'hff);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case %0d: Invalid input digit 15 (F)", test_num);
        digit = 4'hf;
        #1;

        check_outputs(8'hff);
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
        input [7:0] expected_encoding;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoding === (expected_encoding ^ encoding ^ expected_encoding)) begin
                $display("PASS");
                $display("  Outputs: encoding=%h",
                         encoding);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoding=%h",
                         expected_encoding);
                $display("  Got:      encoding=%h",
                         encoding);
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
