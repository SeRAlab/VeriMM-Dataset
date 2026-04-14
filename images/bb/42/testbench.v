`timescale 1ns/1ps

module digital_logic_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg f;
    reg g;
    reg h;
    wire w_pos;
    wire w_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_logic dut (
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .w_pos(w_pos),
        .w_sop(w_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            {e, f, g, h} = 4'b0000;
            $write("Testcase 001: Input 0000 (0) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            {e, f, g, h} = 4'b0001;
            $write("Testcase 002: Input 0001 (1) - ");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            {e, f, g, h} = 4'b0010;
            $write("Testcase 003: Input 0010 (2) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            {e, f, g, h} = 4'b0011;
            $write("Testcase 004: Input 0011 (3) - ");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            {e, f, g, h} = 4'b0100;
            $write("Testcase 005: Input 0100 (4) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            {e, f, g, h} = 4'b0101;
            $write("Testcase 006: Input 0101 (5) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            {e, f, g, h} = 4'b0110;
            $write("Testcase 007: Input 0110 (6) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            {e, f, g, h} = 4'b0111;
            $write("Testcase 008: Input 0111 (7) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            {e, f, g, h} = 4'b1000;
            $write("Testcase 009: Input 1000 (8) - ");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            {e, f, g, h} = 4'b1001;
            $write("Testcase 010: Input 1001 (9) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            {e, f, g, h} = 4'b1010;
            $write("Testcase 011: Input 1010 (10) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            {e, f, g, h} = 4'b1011;
            $write("Testcase 012: Input 1011 (11) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            {e, f, g, h} = 4'b1100;
            $write("Testcase 013: Input 1100 (12) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            {e, f, g, h} = 4'b1101;
            $write("Testcase 014: Input 1101 (13) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            {e, f, g, h} = 4'b1110;
            $write("Testcase 015: Input 1110 (14) - ");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            {e, f, g, h} = 4'b1111;
            $write("Testcase 016: Input 1111 (15) - ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_logic Testbench");
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
        input expected_w_pos;
        input expected_w_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w_pos === (expected_w_pos ^ w_pos ^ expected_w_pos) &&
                expected_w_sop === (expected_w_sop ^ w_sop ^ expected_w_sop)) begin
                $display("PASS");
                $display("  Outputs: w_pos=%b, w_sop=%b",
                         w_pos, w_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_pos=%b, w_sop=%b",
                         expected_w_pos, expected_w_sop);
                $display("  Got:      w_pos=%b, w_sop=%b",
                         w_pos, w_sop);
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
