`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [54:0] data;
    reg [5:0] distance;
    wire [54:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .distance(distance),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 55'h7FF_FFFF_FFFF_FFFF;
            distance = 6'd0;
            $display("Testcase %0d: Shift distance 0 (Identity)", test_num);
            #1;

            check_outputs(55'h7FF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 55'h000_0000_0000_0001;
            distance = 6'd1;
            $display("Testcase %0d: Shift distance 1", test_num);
            #1;

            check_outputs(55'h000_0000_0000_0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 55'h000_0000_0000_0001;
            distance = 6'd54;
            $display("Testcase %0d: Shift to MSB (distance 54)", test_num);
            #1;

            check_outputs(55'h400_0000_0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 55'h7FF_FFFF_FFFF_FFFF;
            distance = 6'd55;
            $display("Testcase %0d: Shift out of bounds (distance 55)", test_num);
            #1;

            check_outputs(55'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 55'h7FF_FFFF_FFFF_FFFF;
            distance = 6'd63;
            $display("Testcase %0d: Maximum distance (distance 63)", test_num);
            #1;

            check_outputs(55'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 55'h000_0000_0000_000F;
            distance = 6'd4;
            $display("Testcase %0d: Nibble shift (distance 4)", test_num);
            #1;

            check_outputs(55'h000_0000_0000_00F0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 55'h2AA_AAAA_AAAA_AAAA;
            distance = 6'd1;
            $display("Testcase %0d: Alternating pattern shift (distance 1)", test_num);

            #1;


            check_outputs(55'h555_5555_5555_5554);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 55'h7FF_FFFF_FFFF_FFFF;
            distance = 6'd8;
            $display("Testcase %0d: Masking check (distance 8)", test_num);
            #1;

            check_outputs(55'h7FF_FFFF_FFFF_FF00);
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
        input [54:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
