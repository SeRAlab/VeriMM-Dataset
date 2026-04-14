`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: 0 * 0");
            test_num = test_num + 1;
            in0 = 8'd0;
            in1 = 8'd0;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 1 * 1");
            test_num = test_num + 1;
            in0 = 8'd1;
            in1 = 8'd1;
            #1;

            check_outputs(16'sd1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 1 * -1");
            test_num = test_num + 1;
            in0 = 8'd1;
            in1 = -8'sd1;
            #1;

            check_outputs(-16'sd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: 255 * 1");
            test_num = test_num + 1;
            in0 = 8'hFF;
            in1 = 8'sd1;
            #1;

            check_outputs(16'sd255);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 255 * -1");
            test_num = test_num + 1;
            in0 = 8'hFF;
            in1 = -8'sd1;
            #1;

            check_outputs(-16'sd255);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 127 * 127");
            test_num = test_num + 1;
            in0 = 8'sd127;
            in1 = 8'sd127;
            #1;

            check_outputs(16'sd16129);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max Positive Case (255 * 127)");
            test_num = test_num + 1;
            in0 = 8'hFF;
            in1 = 8'sd127;
            #1;

            check_outputs(16'sd32385);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Max Negative Case (255 * -128)");
            test_num = test_num + 1;
            in0 = 8'hFF;
            in1 = -8'sd128;
            #1;

            check_outputs(-16'sd32640);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: 128 * -128");
            test_num = test_num + 1;
            in0 = 8'h80;
            in1 = -8'sd128;
            #1;

            check_outputs(-16'sd16384);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: 0 * -128");
            test_num = test_num + 1;
            in0 = 8'd0;
            in1 = -8'sd128;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: 10 * 10");
            test_num = test_num + 1;
            in0 = 8'd10;
            in1 = 8'sd10;
            #1;

            check_outputs(16'sd100);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: 10 * -10");
            test_num = test_num + 1;
            in0 = 8'd10;
            in1 = -8'sd10;
            #1;

            check_outputs(-16'sd100);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
