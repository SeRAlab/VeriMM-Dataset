`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dp;
    reg [3:0] value;
    wire [7:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dp(dp),
        .value(value),
        .segments(segments)
    );
    task testcase001;

    begin
        test_num = 1;
        value = 4'h0;
        dp = 1'b0;
        #1;

        check_outputs(8'hBF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        value = 4'h1;
        dp = 1'b1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        value = 4'h2;
        dp = 1'b0;
        #1;

        check_outputs(8'hDB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        value = 4'h3;
        dp = 1'b1;
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        value = 4'h4;
        dp = 1'b0;
        #1;

        check_outputs(8'hE6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        value = 4'h5;
        dp = 1'b1;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        value = 4'h6;
        dp = 1'b0;
        #1;

        check_outputs(8'hFD);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        value = 4'h7;
        dp = 1'b1;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        value = 4'h8;
        dp = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        value = 4'h9;
        dp = 1'b1;
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        value = 4'hA;
        dp = 1'b0;
        #1;

        check_outputs(8'hF7);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        value = 4'hB;
        dp = 1'b1;
        #1;

        check_outputs(8'h7C);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        value = 4'hC;
        dp = 1'b0;
        #1;

        check_outputs(8'hB9);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        value = 4'hD;
        dp = 1'b1;
        #1;

        check_outputs(8'h5E);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        value = 4'hE;
        dp = 1'b0;
        #1;

        check_outputs(8'hF9);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        value = 4'hF;
        dp = 1'b1;
        #1;

        check_outputs(8'h71);
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
        input [7:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: segments=%h",
                         segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h",
                         expected_segments);
                $display("  Got:      segments=%h",
                         segments);
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
