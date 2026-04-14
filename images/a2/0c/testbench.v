`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire [6:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input D = 0", test_num);
        D = 4'h0;
        #1;

        check_outputs(7'h40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input D = 1", test_num);
        D = 4'h1;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input D = 2", test_num);
        D = 4'h2;
        #1;

        check_outputs(7'h24);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input D = 3", test_num);
        D = 4'h3;
        #1;

        check_outputs(7'h30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input D = 4", test_num);
        D = 4'h4;
        #1;

        check_outputs(7'h19);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input D = 5", test_num);
        D = 4'h5;
        #1;

        check_outputs(7'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input D = 6", test_num);
        D = 4'h6;
        #1;

        check_outputs(7'h02);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input D = 7", test_num);
        D = 4'h7;
        #1;

        check_outputs(7'h78);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input D = 8", test_num);
        D = 4'h8;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input D = 9", test_num);
        D = 4'h9;
        #1;

        check_outputs(7'h10);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Input D = 10 (A)", test_num);
        D = 4'hA;
        #1;

        check_outputs(7'h08);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Input D = 11 (b)", test_num);
        D = 4'hB;
        #1;

        check_outputs(7'h03);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: Input D = 12 (C)", test_num);
        D = 4'hC;
        #1;

        check_outputs(7'h46);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: Input D = 13 (d)", test_num);
        D = 4'hD;
        #1;

        check_outputs(7'h21);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: Input D = 14 (E)", test_num);
        D = 4'hE;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: Input D = 15 (F)", test_num);
        D = 4'hF;
        #1;

        check_outputs(7'h0E);
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
        input [6:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
