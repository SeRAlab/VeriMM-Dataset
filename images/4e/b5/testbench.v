`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] iSRC_DATA;
    reg [3:0] iSRC_MASK;
    wire [31:0] oDEST_DATA;
    wire [3:0] oDEST_MASK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iSRC_DATA(iSRC_DATA),
        .iSRC_MASK(iSRC_MASK),
        .oDEST_DATA(oDEST_DATA),
        .oDEST_MASK(oDEST_MASK)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Full 32-bit byte swap", test_num);
            iSRC_DATA = 32'h12345678;
            iSRC_MASK = 4'b1111;
            #1;

            check_outputs(32'h78563412, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single byte swap (LSB)", test_num);
            iSRC_DATA = 32'h000000FF;
            iSRC_MASK = 4'b0001;
            #1;

            check_outputs(32'hFF000000, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Single byte swap (MSB)", test_num);
            iSRC_DATA = 32'hAA000000;
            iSRC_MASK = 4'b1000;
            #1;

            check_outputs(32'h000000AA, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Middle bytes swap", test_num);
            iSRC_DATA = 32'h00BBAA00;
            iSRC_MASK = 4'b0110;
            #1;

            check_outputs(32'h00AA_BB00, 4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Irregular data and mask swap", test_num);
            iSRC_DATA = 32'hDEADBEEF;
            iSRC_MASK = 4'b1011;


            #1;



            check_outputs(32'hEFBEADDE, 4'b1101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: All zeros", test_num);
            iSRC_DATA = 32'h00000000;
            iSRC_MASK = 4'b0000;
            #1;

            check_outputs(32'h00000000, 4'b0000);
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
        input [31:0] expected_oDEST_DATA;
        input [3:0] expected_oDEST_MASK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oDEST_DATA === (expected_oDEST_DATA ^ oDEST_DATA ^ expected_oDEST_DATA) &&
                expected_oDEST_MASK === (expected_oDEST_MASK ^ oDEST_MASK ^ expected_oDEST_MASK)) begin
                $display("PASS");
                $display("  Outputs: oDEST_DATA=%h, oDEST_MASK=%h",
                         oDEST_DATA, oDEST_MASK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oDEST_DATA=%h, oDEST_MASK=%h",
                         expected_oDEST_DATA, expected_oDEST_MASK);
                $display("  Got:      oDEST_DATA=%h, oDEST_MASK=%h",
                         oDEST_DATA, oDEST_MASK);
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
