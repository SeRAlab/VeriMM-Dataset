`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg or_info;
    reg [1:0] round_mode;
    reg xor_info;
    wire ctrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .or_info(or_info),
        .round_mode(round_mode),
        .xor_info(xor_info),
        .ctrl(ctrl)
    );
    task testcase001;

        begin
            test_num = 1;
            round_mode = 2'b00; or_info = 1'b0; xor_info = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            round_mode = 2'b00; or_info = 1'b0; xor_info = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            round_mode = 2'b00; or_info = 1'b1; xor_info = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            round_mode = 2'b00; or_info = 1'b1; xor_info = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            round_mode = 2'b01; or_info = 1'b0; xor_info = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            round_mode = 2'b01; or_info = 1'b1; xor_info = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            round_mode = 2'b10; or_info = 1'b0; xor_info = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            round_mode = 2'b10; or_info = 1'b0; xor_info = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            round_mode = 2'b10; or_info = 1'b1; xor_info = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            round_mode = 2'b10; or_info = 1'b1; xor_info = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            round_mode = 2'b11; or_info = 1'b0; xor_info = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            round_mode = 2'b11; or_info = 1'b0; xor_info = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            round_mode = 2'b11; or_info = 1'b1; xor_info = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            round_mode = 2'b11; or_info = 1'b1; xor_info = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            round_mode = 2'b01; or_info = 1'b0; xor_info = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            round_mode = 2'b01; or_info = 1'b1; xor_info = 1'b0;
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
        input expected_ctrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ctrl === (expected_ctrl ^ ctrl ^ expected_ctrl)) begin
                $display("PASS");
                $display("  Outputs: ctrl=%b",
                         ctrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctrl=%b",
                         expected_ctrl);
                $display("  Got:      ctrl=%b",
                         ctrl);
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
