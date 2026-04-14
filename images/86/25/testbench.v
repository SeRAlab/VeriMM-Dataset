`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] c;
    wire [10:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        c = 15'h0000;
        $display("Test %0d: Data 11'h000, No Error", test_num);
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        c = 15'h7FFF;
        $display("Test %0d: Data 11'h7FF, No Error", test_num);
        #1;

        check_outputs(11'h7FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        c = 15'h5A25;
        $display("Test %0d: Data 11'h5A5, No Error", test_num);
        #1;

        check_outputs(11'h5A5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        c = 15'h331E;
        $display("Test %0d: Data 11'h333, No Error", test_num);
        #1;

        check_outputs(11'h333);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        c = 15'h0001;
        $display("Test %0d: Data 11'h000, Error at Pos 1 (P1)", test_num);
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        c = 15'h0004;
        $display("Test %0d: Data 11'h000, Error at Pos 3 (D1)", test_num);
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        c = 15'h7F7F;
        $display("Test %0d: Data 11'h7FF, Error at Pos 8 (P8)", test_num);
        #1;

        check_outputs(11'h7FF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        c = 15'h3FFF;
        $display("Test %0d: Data 11'h7FF, Error at Pos 15 (D11)", test_num);
        #1;

        check_outputs(11'h7FF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        c = 15'h5A05;
        $display("Test %0d: Data 11'h5A5, Error at Pos 6 (D3)", test_num);
        #1;

        check_outputs(11'h5A5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        c = 15'h371E;
        $display("Test %0d: Data 11'h333, Error at Pos 11 (D7)", test_num);
        #1;

        check_outputs(11'h333);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        c = 15'h2D1E;
        $display("Test %0d: Data 11'h2D3, No Error", test_num);
        #1;

        check_outputs(11'h2D3);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        c = 15'h2C1E;
        $display("Test %0d: Data 11'h2D3, Error at Pos 9 (D5)", test_num);
        #1;

        check_outputs(11'h2D3);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        c = 15'h4411;
        $display("Test %0d: Data 11'h482, No Error", test_num);
        #1;

        check_outputs(11'h482);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        c = 15'h4401;
        $display("Test %0d: Data 11'h482, Error at Pos 5 (D2)", test_num);
        #1;

        check_outputs(11'h482);
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
        input [10:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
