`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dec_in;
    wire [22:0] dec_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dec_in(dec_in),
        .dec_out(dec_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0", test_num);
            dec_in = 5'd0;
            #1;

            check_outputs(23'h000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 1", test_num);
            dec_in = 5'd1;
            #1;

            check_outputs(23'h000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 5", test_num);
            dec_in = 5'd5;
            #1;

            check_outputs(23'h000020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 10", test_num);
            dec_in = 5'd10;
            #1;

            check_outputs(23'h000400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15", test_num);
            dec_in = 5'd15;
            #1;

            check_outputs(23'h008000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 21", test_num);
            dec_in = 5'd21;
            #1;

            check_outputs(23'h200000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 22 (Max valid line)", test_num);
            dec_in = 5'd22;
            #1;

            check_outputs(23'h400000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 23 (Out of range)", test_num);
            dec_in = 5'd23;

            #1;


            check_outputs(23'h000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 31 (Out of range edge)", test_num);
            dec_in = 5'd31;
            #1;

            check_outputs(23'h000000);
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
        input [22:0] expected_dec_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec_out === (expected_dec_out ^ dec_out ^ expected_dec_out)) begin
                $display("PASS");
                $display("  Outputs: dec_out=%h",
                         dec_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec_out=%h",
                         expected_dec_out);
                $display("  Got:      dec_out=%h",
                         dec_out);
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
