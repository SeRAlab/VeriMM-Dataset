`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] din_data;
    reg din_last;
    reg din_valid;
    reg dout_ready;
    wire din_ready;
    wire [63:0] dout_data;
    wire dout_last;
    wire dout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_data(din_data),
        .din_last(din_last),
        .din_valid(din_valid),
        .dout_ready(dout_ready),
        .din_ready(din_ready),
        .dout_data(dout_data),
        .dout_last(dout_last),
        .dout_valid(dout_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer (Ready=1, Valid=1)", test_num);
            din_data = 64'hDEADBEEFCAFEBABE;
            din_last = 0;
            din_valid = 1;
            dout_ready = 1;
            #1;

            check_outputs(1, 64'hDEADBEEFCAFEBABE, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Backpressure (Ready=0, Valid=1)", test_num);
            din_data = 64'h1122334455667788;
            din_last = 0;
            din_valid = 1;
            dout_ready = 0;

            #1;


            check_outputs(0, 64'h1122334455667788, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: End of Stream (Last=1)", test_num);
            din_data = 64'hFFFFFFFF00000000;
            din_last = 1;
            din_valid = 1;
            dout_ready = 1;
            #1;

            check_outputs(1, 64'hFFFFFFFF00000000, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Idle State (Valid=0)", test_num);
            din_data = 64'h0;
            din_last = 0;
            din_valid = 0;
            dout_ready = 1;
            #1;

            check_outputs(1, 64'h0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Blocking (Ready=0, Valid=0)", test_num);
            din_data = 64'hA5A5A5A5A5A5A5A5;
            din_last = 1;
            din_valid = 0;
            dout_ready = 0;
            #1;

            check_outputs(0, 64'hA5A5A5A5A5A5A5A5, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Bit Pattern Check (Alternating Bits)", test_num);
            din_data = 64'h5555555555555555;
            din_last = 0;
            din_valid = 1;
            dout_ready = 1;
            #1;

            check_outputs(1, 64'h5555555555555555, 0, 1);
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
        input expected_din_ready;
        input [63:0] expected_dout_data;
        input expected_dout_last;
        input expected_dout_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_dout_data === (expected_dout_data ^ dout_data ^ expected_dout_data) &&
                expected_dout_last === (expected_dout_last ^ dout_last ^ expected_dout_last) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid)) begin
                $display("PASS");
                $display("  Outputs: din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b",
                         din_ready, dout_data, dout_last, dout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b",
                         expected_din_ready, expected_dout_data, expected_dout_last, expected_dout_valid);
                $display("  Got:      din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b",
                         din_ready, dout_data, dout_last, dout_valid);
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
