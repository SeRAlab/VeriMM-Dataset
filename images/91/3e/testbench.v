`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] X1;
    reg [3:0] X2;
    reg cin;
    wire [3:0] S;
    wire c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X1(X1),
        .X2(X2),
        .cin(cin),
        .S(S),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        X1 = 4'b0000; X2 = 4'b0000; cin = 0;
        #1;

        check_outputs(4'b0000, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        X1 = 4'h5; X2 = 4'h2; cin = 0;
        #1;

        check_outputs(4'h7, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        X1 = 4'h3; X2 = 4'h4; cin = 1;
        #1;

        check_outputs(4'h8, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        X1 = 4'hF; X2 = 4'h0; cin = 1;
        #1;

        check_outputs(4'h0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        X1 = 4'h8; X2 = 4'h8; cin = 0;
        #1;

        check_outputs(4'h0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        X1 = 4'hF; X2 = 4'hF; cin = 1;
        #1;

        check_outputs(4'hF, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        X1 = 4'hA; X2 = 4'h5; cin = 0;
        #1;

        check_outputs(4'hF, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        X1 = 4'hA; X2 = 4'h5; cin = 1;
        #1;

        check_outputs(4'h0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        X1 = 4'h7; X2 = 4'h0; cin = 1;
        #1;

        check_outputs(4'h8, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        X1 = 4'hB; X2 = 4'h6; cin = 0;
        #1;

        check_outputs(4'h1, 1);
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
        input [3:0] expected_S;
        input expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: S=%h, c=%b",
                         S, c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, c=%b",
                         expected_S, expected_c);
                $display("  Got:      S=%h, c=%b",
                         S, c);
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
