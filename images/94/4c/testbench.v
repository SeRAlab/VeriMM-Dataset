`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] Tula;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] saidaULA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Tula(Tula),
        .a(a),
        .b(b),
        .saidaULA(saidaULA)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero addition (0 + 0)", test_num);
            a = 4'd0;
            b = 4'd0;
            Tula = 3'b000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic addition (5 + 3)", test_num);
            a = 4'd5;
            b = 4'd3;
            Tula = 3'b000;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition resulting in max value (7 + 8)", test_num);
            a = 4'd7;
            b = 4'd8;
            Tula = 3'b000;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with overflow (15 + 1)", test_num);
            a = 4'd15;
            b = 4'd1;
            Tula = 3'b000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with max inputs (15 + 15)", test_num);
            a = 4'd15;
            b = 4'd15;
            Tula = 3'b000;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Adding zero to a value (12 + 0)", test_num);
            a = 4'd12;
            b = 4'd0;
            Tula = 3'b000;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Smallest overflow (8 + 8)", test_num);
            a = 4'd8;
            b = 4'd8;
            Tula = 3'b000;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_saidaULA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saidaULA === (expected_saidaULA ^ saidaULA ^ expected_saidaULA)) begin
                $display("PASS");
                $display("  Outputs: saidaULA=%h",
                         saidaULA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saidaULA=%h",
                         expected_saidaULA);
                $display("  Got:      saidaULA=%h",
                         saidaULA);
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
