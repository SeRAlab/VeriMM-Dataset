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
            $display("Test %0d: Zero distance shift (Identity)", test_num);
            data = 55'h7AAA_AAAA_AAAA_AAA;
            distance = 6'd0;
            #1;

            check_outputs(55'h7AAA_AAAA_AAAA_AAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift left by 1", test_num);
            data = 55'h0000_0000_0000_001;
            distance = 6'd1;
            #1;

            check_outputs(55'h0000_0000_0000_002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift left by 4", test_num);
            data = 55'h0000_0000_0000_00F;
            distance = 6'd4;
            #1;

            check_outputs(55'h0000_0000_0000_0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift to the MSB (bit 54)", test_num);
            data = 55'h0000_0000_0000_001;
            distance = 6'd54;
            #1;

            check_outputs(55'h4000_0000_0000_000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data overflow (shifting out bits)", test_num);
            data = 55'h4000_0000_0000_000;
            distance = 6'd1;
            #1;

            check_outputs(55'h0000_0000_0000_000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Distance exceeding bit width", test_num);
            data = 55'h7FFF_FFFF_FFFF_FFF;
            distance = 6'd55;
            #1;

            check_outputs(55'h0000_0000_0000_000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: All ones data with medium shift", test_num);
            data = 55'h7FFF_FFFF_FFFF_FFF;
            distance = 6'd20;

            #1;


            check_outputs(55'h7FF_FFFF_FF00_000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Patterned data shift", test_num);
            data = 55'h5555_5555_5555_555;
            distance = 6'd2;

            #1;


            check_outputs(55'h555_5555_5555_554);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Max distance value (63)", test_num);
            data = 55'h7FFF_FFFF_FFFF_FFF;
            distance = 6'd63;
            #1;

            check_outputs(55'h0000_0000_0000_000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Alternating bit pattern shift", test_num);
            data = 55'h1234_5678_9ABC_DEF;
            distance = 6'd8;
            #1;

            check_outputs(55'h3456_789A_BCD_EF00);
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
