`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [6:0] SSEG_L;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .SSEG_L(SSEG_L)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 0", test_num);
        B = 4'h0;
        #10;
        #1;

        check_outputs(7'h40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 1", test_num);
        B = 4'h1;
        #10;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 2", test_num);
        B = 4'h2;
        #10;
        #1;

        check_outputs(7'h24);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 3", test_num);
        B = 4'h3;
        #10;
        #1;

        check_outputs(7'h30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 4", test_num);
        B = 4'h4;
        #10;
        #1;

        check_outputs(7'h19);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 5", test_num);
        B = 4'h5;
        #10;
        #1;

        check_outputs(7'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 6", test_num);
        B = 4'h6;
        #10;
        #1;

        check_outputs(7'h02);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 7", test_num);
        B = 4'h7;
        #10;
        #1;

        check_outputs(7'h78);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 8", test_num);
        B = 4'h8;
        #10;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit 9", test_num);
        B = 4'h9;
        #10;
        #1;

        check_outputs(7'h10);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit A", test_num);
        B = 4'hA;
        #10;
        #1;

        check_outputs(7'h08);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit B", test_num);
        B = 4'hB;
        #10;
        #1;

        check_outputs(7'h03);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit C", test_num);
        B = 4'hC;
        #10;
        #1;

        check_outputs(7'h46);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit D", test_num);
        B = 4'hD;
        #10;
        #1;

        check_outputs(7'h21);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit E", test_num);
        B = 4'hE;
        #10;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Digit F", test_num);
        B = 4'hF;
        #10;
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
        input [6:0] expected_SSEG_L;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SSEG_L === (expected_SSEG_L ^ SSEG_L ^ expected_SSEG_L)) begin
                $display("PASS");
                $display("  Outputs: SSEG_L=%h",
                         SSEG_L);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSEG_L=%h",
                         expected_SSEG_L);
                $display("  Got:      SSEG_L=%h",
                         SSEG_L);
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
