`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] select;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .select(select),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            select = 4'd0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            select = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            select = 4'd2;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            select = 4'd3;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            select = 4'd4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            select = 4'd5;
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            select = 4'd6;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            select = 4'd7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            select = 4'd8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            select = 4'd9;
            #1;

            check_outputs(16'h0200);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            select = 4'd10;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            select = 4'd11;
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            select = 4'd12;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            select = 4'd13;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            select = 4'd14;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            select = 4'd15;
            #1;

            check_outputs(16'h8000);
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
