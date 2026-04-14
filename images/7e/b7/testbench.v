`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    wire seg3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .seg3(seg3)
    );
    task testcase001;

        begin
            {c3, c2, c1, c0} = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            {c3, c2, c1, c0} = 4'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            {c3, c2, c1, c0} = 4'd2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            {c3, c2, c1, c0} = 4'd3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            {c3, c2, c1, c0} = 4'd4;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            {c3, c2, c1, c0} = 4'd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            {c3, c2, c1, c0} = 4'd6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            {c3, c2, c1, c0} = 4'd7;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            {c3, c2, c1, c0} = 4'd8;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            {c3, c2, c1, c0} = 4'd9;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            {c3, c2, c1, c0} = 4'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            {c3, c2, c1, c0} = 4'd11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            {c3, c2, c1, c0} = 4'd12;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase014;

        begin
            {c3, c2, c1, c0} = 4'd13;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase015;

        begin
            {c3, c2, c1, c0} = 4'd14;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase016;

        begin
            {c3, c2, c1, c0} = 4'd15;
            #1;

            check_outputs(1'b0);
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
        input expected_seg3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg3 === (expected_seg3 ^ seg3 ^ expected_seg3)) begin
                $display("PASS");
                $display("  Outputs: seg3=%b",
                         seg3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg3=%b",
                         expected_seg3);
                $display("  Got:      seg3=%b",
                         seg3);
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
