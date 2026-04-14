`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] data_keys;
    reg halt_key;
    wire [15:0] data_in;
    wire halt_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_keys(data_keys),
        .halt_key(halt_key),
        .data_in(data_in),
        .halt_in(halt_in)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data_keys = 7'b0000000;
            halt_key = 1'b0;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data_keys = 7'b0001010;
            halt_key = 1'b0;
            #1;

            check_outputs(16'h000A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data_keys = 7'b0111111;
            halt_key = 1'b1;
            #1;

            check_outputs(16'h003F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data_keys = 7'b1111111;
            halt_key = 1'b0;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data_keys = 7'b1110110;
            halt_key = 1'b1;
            #1;

            check_outputs(16'hFFF6, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data_keys = 7'b1000000;
            halt_key = 1'b0;
            #1;

            check_outputs(16'hFFC0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data_keys = 7'b0010101;
            halt_key = 1'b1;
            #1;

            check_outputs(16'h0015, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            data_keys = 7'b1011010;
            halt_key = 1'b0;
            #1;

            check_outputs(16'hFFDA, 1'b0);
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
        input [15:0] expected_data_in;
        input expected_halt_in;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_in === (expected_data_in ^ data_in ^ expected_data_in) &&
                expected_halt_in === (expected_halt_in ^ halt_in ^ expected_halt_in)) begin
                $display("PASS");
                $display("  Outputs: data_in=%h, halt_in=%b",
                         data_in, halt_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_in=%h, halt_in=%b",
                         expected_data_in, expected_halt_in);
                $display("  Got:      data_in=%h, halt_in=%b",
                         data_in, halt_in);
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
