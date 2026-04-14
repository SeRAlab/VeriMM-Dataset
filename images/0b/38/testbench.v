`timescale 1ns/1ps

module median_filter_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in00;
    reg [2:0] in01;
    reg [2:0] in02;
    reg [2:0] in10;
    reg [2:0] in11;
    reg [2:0] in12;
    reg [2:0] in20;
    reg [2:0] in21;
    reg [2:0] in22;
    wire [2:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter_3x3 dut (
        .in00(in00),
        .in01(in01),
        .in02(in02),
        .in10(in10),
        .in11(in11),
        .in12(in12),
        .in20(in20),
        .in21(in21),
        .in22(in22),
        .median(median)
    );
    task set_inputs;

        input [2:0] i00, i01, i02, i10, i11, i12, i20, i21, i22;
        begin
            test_num = test_num + 1;
            in00 = i00; in01 = i01; in02 = i02;
            in10 = i10; in11 = i11; in12 = i12;
            in20 = i20; in21 = i21; in22 = i22;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: All inputs identical (4)");
            set_inputs(4, 4, 4, 4, 4, 4, 4, 4, 4);
            #1;

            check_outputs(4);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sorted sequence 0-7 + extra 0");
            set_inputs(0, 1, 2, 3, 4, 5, 6, 7, 0);
            #1;

            check_outputs(3);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Reverse sorted sequence 7-0 + extra 7");
            set_inputs(7, 6, 5, 4, 3, 2, 1, 0, 7);
            #1;

            check_outputs(4);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Majority zeros");
            set_inputs(0, 5, 0, 1, 0, 7, 0, 2, 0);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Majority sevens");
            set_inputs(7, 1, 7, 2, 7, 3, 7, 4, 7);
            #1;

            check_outputs(7);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Random distribution 1");
            set_inputs(5, 2, 1, 7, 6, 0, 4, 3, 5);
            #1;

            check_outputs(4);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Middle cluster (3s and 4s)");
            set_inputs(3, 4, 3, 4, 3, 4, 3, 4, 3);
            #1;

            check_outputs(3);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Impulse noise (High)");
            set_inputs(1, 1, 1, 1, 7, 1, 1, 1, 1);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Impulse noise (Low)");
            set_inputs(6, 6, 6, 6, 0, 6, 6, 6, 6);
            #1;

            check_outputs(6);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Random distribution 2");
            set_inputs(2, 5, 3, 6, 1, 4, 0, 7, 2);
            #1;

            check_outputs(3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("median_filter_3x3 Testbench");
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
        input [2:0] expected_median;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_median === (expected_median ^ median ^ expected_median)) begin
                $display("PASS");
                $display("  Outputs: median=%h",
                         median);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: median=%h",
                         expected_median);
                $display("  Got:      median=%h",
                         median);
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
