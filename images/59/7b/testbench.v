`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg [2:0] idx;
    wire [3:0] slice_down;
    wire [3:0] slice_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .idx(idx),
        .slice_down(slice_down),
        .slice_up(slice_up)
    );
    task testcase001;

    begin
        test_num = 1;
        data = 32'hFFFF_FFBA;
        idx = 3'd1;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'hA, 4'hB);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data = 32'hFFFF_BAFF;
        idx = 3'd3;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'hA, 4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data = 32'hFFBA_FFFF;
        idx = 3'd5;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'hA, 4'hB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data = 32'hBAFF_FFFF;
        idx = 3'd7;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'hA, 4'hB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data = 32'h1234_5678;
        idx = 3'd2;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'h7, 4'h6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data = 32'h8765_4321;
        idx = 3'd7;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'h7, 4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data = 32'hABCD_EF01;
        idx = 3'd4;
        $display("Testcase %0d: idx=%d, data=%h", test_num, idx, data);
        #1;

        check_outputs(4'hE, 4'hD);
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
        input [3:0] expected_slice_down;
        input [3:0] expected_slice_up;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_slice_down === (expected_slice_down ^ slice_down ^ expected_slice_down) &&
                expected_slice_up === (expected_slice_up ^ slice_up ^ expected_slice_up)) begin
                $display("PASS");
                $display("  Outputs: slice_down=%h, slice_up=%h",
                         slice_down, slice_up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: slice_down=%h, slice_up=%h",
                         expected_slice_down, expected_slice_up);
                $display("  Got:      slice_down=%h, slice_up=%h",
                         slice_down, slice_up);
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
