`timescale 1ns/1ps

module A_star_Evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] C;
    reg EN;
    reg [3:0] H;
    wire [4:0] E;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    A_star_Evaluator dut (
        .C(C),
        .EN(EN),
        .H(H),
        .E(E)
    );
    task testcase001;

        begin
            test_num = 1;
            EN = 1;
            H = 4'd5;
            C = 4'd3;
            $display("Test Case 001: EN=1, H=5, C=3 -> Expected E=8");
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            EN = 1;
            H = 4'd15;
            C = 4'd15;
            $display("Test Case 002: EN=1, H=15, C=15 -> Expected E=30");
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            EN = 1;
            H = 4'd0;
            C = 4'd0;
            $display("Test Case 003: EN=1, H=0, C=0 -> Expected E=0");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            EN = 0;
            H = 4'd10;
            C = 4'd5;
            $display("Test Case 004: EN=0, H=10, C=5 -> Expected E=0 (Invalid)");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            EN = 1;
            H = 4'd10;
            C = 4'd0;
            $display("Test Case 005: EN=1, H=10, C=0 -> Expected E=10");
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            EN = 1;
            H = 4'd0;
            C = 4'd7;
            $display("Test Case 006: EN=1, H=0, C=7 -> Expected E=7");
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            EN = 0;
            H = 4'd15;
            C = 4'd15;
            $display("Test Case 007: EN=0, H=15, C=15 -> Expected E=0 (Invalid)");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            EN = 1;
            H = 4'd8;
            C = 4'd8;
            $display("Test Case 008: EN=1, H=8, C=8 -> Expected E=16");
            #1;

            check_outputs(5'd16);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("A_star_Evaluator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [4:0] expected_E;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_E === (expected_E ^ E ^ expected_E)) begin
                $display("PASS");
                $display("  Outputs: E=%h",
                         E);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%h",
                         expected_E);
                $display("  Got:      E=%h",
                         E);
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
