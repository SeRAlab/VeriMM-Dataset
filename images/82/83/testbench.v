`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] B;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 16'hABCD;
            B = 4'd0;
            $display("Testcase %0d: No shift (A=%h, B=%d)", test_num, A, B);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 16'h8001;
            B = 4'd1;
            $display("Testcase %0d: Circular shift left 1 (A=%h, B=%d)", test_num, A, B);

            #1;


            check_outputs(16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 16'hF000;
            B = 4'd4;
            $display("Testcase %0d: Circular shift left 4 (A=%h, B=%d)", test_num, A, B);
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 16'h1234;
            B = 4'd8;
            $display("Testcase %0d: Circular shift left 8 (A=%h, B=%d)", test_num, A, B);
            #1;

            check_outputs(16'h3412);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 16'hCDEF;
            B = 4'd12;
            $display("Testcase %0d: Circular shift left 12 (A=%h, B=%d)", test_num, A, B);

            #1;


            check_outputs(16'hFCDE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 16'h0001;
            B = 4'd15;
            $display("Testcase %0d: Circular shift left 15 (A=%h, B=%d)", test_num, A, B);

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 16'h0000;
            B = 4'd7;
            $display("Testcase %0d: Shift zero value (A=%h, B=%d)", test_num, A, B);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 16'hFFFF;
            B = 4'd10;
            $display("Testcase %0d: Shift all-ones value (A=%h, B=%d)", test_num, A, B);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 16'hAAAA;
            B = 4'd1;
            $display("Testcase %0d: Shift alternating bits (A=%h, B=%d)", test_num, A, B);

            #1;


            check_outputs(16'h5555);
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
