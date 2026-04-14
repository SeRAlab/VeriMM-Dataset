`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] A;
    reg [8:0] B;
    wire [9:0] O;

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
        A = 9'd5; B = 9'd10;
        #1;

        check_outputs(10'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 9'h1FB; B = 9'h1F6;
        #1;

        check_outputs(10'h3F1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 9'd200; B = 9'd100;
        #1;

        check_outputs(10'd300);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 9'h138; B = 9'h19C;
        #1;

        check_outputs(10'h2D4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 9'h0FF; B = 9'h0FF;
        #1;

        check_outputs(10'h1FE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 9'h100; B = 9'h100;
        #1;

        check_outputs(10'h200);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 9'h07F; B = 9'h181;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 9'h100; B = 9'h0FF;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 9'h180; B = 9'h040;
        #1;

        check_outputs(10'h3C0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 9'h000; B = 9'h000;
        #1;

        check_outputs(10'h000);
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
        input [9:0] expected_O;
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
