`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] A;
    reg [5:0] B;
    wire [5:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 6'd0; B = 6'd0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 6'd1; B = 6'd0;
        #1;

        check_outputs(6'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 6'd0; B = 6'd2;
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 6'd1; B = 6'd2;
        #1;

        check_outputs(6'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 6'd16; B = 6'd0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 6'd3; B = 6'd10;
        #1;

        check_outputs(6'd17);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 6'd63; B = 6'd0;
        #1;

        check_outputs(6'd60);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 6'd0; B = 6'd63;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 6'd15; B = 6'd1;
        #1;

        check_outputs(6'd60);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 6'd15; B = 6'd63;
        #1;

        check_outputs(6'd27);
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
        input [5:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
