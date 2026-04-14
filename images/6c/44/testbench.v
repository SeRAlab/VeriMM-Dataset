`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [3:0] dec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .dec(dec)
    );
    task testcase001;

        begin
            test_num = 1;
            bin = 4'd0;
            #10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            bin = 4'd1;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            bin = 4'd2;
            #10;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            bin = 4'd3;
            #10;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            bin = 4'd4;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            bin = 4'd5;
            #10;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            bin = 4'd6;
            #10;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            bin = 4'd7;
            #10;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            bin = 4'd8;
            #10;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            bin = 4'd9;
            #10;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            bin = 4'd10;
            #10;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            bin = 4'd12;
            #10;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            bin = 4'd15;
            #10;
            #1;

            check_outputs(4'd7);
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
        input [3:0] expected_dec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec === (expected_dec ^ dec ^ expected_dec)) begin
                $display("PASS");
                $display("  Outputs: dec=%h",
                         dec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec=%h",
                         expected_dec);
                $display("  Got:      dec=%h",
                         dec);
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
