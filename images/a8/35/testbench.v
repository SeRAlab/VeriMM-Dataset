`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] id0_m;
    reg [9:0] id1_m;
    reg [9:0] id2_m;
    reg [9:0] id3_m;
    wire [3:0] mask_id;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .id0_m(id0_m),
        .id1_m(id1_m),
        .id2_m(id2_m),
        .id3_m(id3_m),
        .mask_id(mask_id)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            id0_m = 10'b00_0000_0000;
            id1_m = 10'b00_0000_0000;
            id2_m = 10'b00_0000_0000;
            id3_m = 10'b00_0000_0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs all-ones (10 ones = Even)", test_num);
            id0_m = 10'b11_1111_1111;
            id1_m = 10'b11_1111_1111;
            id2_m = 10'b11_1111_1111;
            id3_m = 10'b11_1111_1111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set per input (Odd parity)", test_num);
            id0_m = 10'h001;
            id1_m = 10'h002;
            id2_m = 10'h040;
            id3_m = 10'h200;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed parities (E, O, E, O)", test_num);
            id0_m = 10'b00_0000_0011;
            id1_m = 10'b00_0000_0111;
            id2_m = 10'b01_0101_0101;


            id0_m = 10'h003;
            id1_m = 10'h007;
            id2_m = 10'h3FF;
            id3_m = 10'h3FE;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed parities (O, E, O, E)", test_num);
            id0_m = 10'h001;
            id1_m = 10'h003;
            id2_m = 10'h007;
            id3_m = 10'h00F;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Odd (9 bits set each)", test_num);
            id0_m = 10'b01_1111_1111;
            id1_m = 10'b10_1111_1111;
            id2_m = 10'b11_0111_1111;
            id3_m = 10'b11_1111_1110;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific bit patterns", test_num);
            id0_m = 10'h155;
            id1_m = 10'h2AA;
            id2_m = 10'h000;
            id3_m = 10'h3FF;
            #1;

            check_outputs(4'b0011);
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
        input [3:0] expected_mask_id;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mask_id === (expected_mask_id ^ mask_id ^ expected_mask_id)) begin
                $display("PASS");
                $display("  Outputs: mask_id=%h",
                         mask_id);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mask_id=%h",
                         expected_mask_id);
                $display("  Got:      mask_id=%h",
                         mask_id);
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
