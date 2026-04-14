`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    reg en;
    reg v;
    wire pb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .en(en),
        .v(v),
        .pb(pb)
    );
    task testcase001;

        begin
            $display("Testcase 001: en=0, parity should be 0 regardless of inputs.");
            d = 8'hAA;
            v = 1'b1;
            en = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: en=0, input d=0, v=0.");
            d = 8'h00;
            v = 1'b0;
            en = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: en=1, d=00000000, v=0. Parity should be 0.");
            d = 8'h00;
            v = 1'b0;
            en = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: en=1, d=00000001, v=0. Parity should be 1.");
            d = 8'h01;
            v = 1'b0;
            en = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: en=1, d=00000001, v=1. Parity (1^1) should be 0.");
            d = 8'h01;
            v = 1'b1;
            en = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: en=1, d=00000011, v=0. Parity (1^1^0) should be 0.");
            d = 8'h03;
            v = 1'b0;
            en = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: en=1, d=00000011, v=1. Parity (1^1^1) should be 1.");
            d = 8'h03;
            v = 1'b1;
            en = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: en=1, d=11111111, v=0. Parity (even num of 1s) should be 0.");
            d = 8'hFF;
            v = 1'b0;
            en = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: en=1, d=11111111, v=1. Parity (0^1) should be 1.");
            d = 8'hFF;
            v = 1'b1;
            en = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: en=1, d=10101011, v=0. Parity (5 bits set) should be 1.");
            d = 8'hAB;
            v = 1'b0;
            en = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_pb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pb === (expected_pb ^ pb ^ expected_pb)) begin
                $display("PASS");
                $display("  Outputs: pb=%b",
                         pb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pb=%b",
                         expected_pb);
                $display("  Got:      pb=%b",
                         pb);
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
