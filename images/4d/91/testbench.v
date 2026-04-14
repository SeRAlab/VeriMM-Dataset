`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_0;
    reg [31:0] data_1;
    reg [31:0] data_2;
    reg [31:0] data_3;
    reg [31:0] data_4;
    reg [2:0] selector;
    wire [31:0] mux_iord_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_4(data_4),
        .selector(selector),
        .mux_iord_out(mux_iord_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select data_0 (selector=000)", test_num);
            data_0 = 32'hAAAA_AAAA;
            data_1 = 32'hBBBB_BBBB;
            data_2 = 32'hCCCC_CCCC;
            data_3 = 32'hDDDD_DDDD;
            data_4 = 32'hEEEE_EEEE;
            selector = 3'b000;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select data_1 (selector=001)", test_num);
            data_0 = 32'hAAAA_AAAA;
            data_1 = 32'hBBBB_BBBB;
            data_2 = 32'hCCCC_CCCC;
            data_3 = 32'hDDDD_DDDD;
            data_4 = 32'hEEEE_EEEE;
            selector = 3'b001;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select data_2 (selector=010)", test_num);
            data_0 = 32'h1234_5678;
            data_1 = 32'h2345_6789;
            data_2 = 32'h3456_789A;
            data_3 = 32'h4567_89AB;
            data_4 = 32'h5678_9ABC;
            selector = 3'b010;
            #1;

            check_outputs(32'h3456_789A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select data_3 (selector=011)", test_num);
            data_0 = 32'hFFFF_0000;
            data_1 = 32'h0000_FFFF;
            data_2 = 32'hF0F0_F0F0;
            data_3 = 32'h0F0F_0F0F;
            data_4 = 32'hAAAA_5555;
            selector = 3'b011;
            #1;

            check_outputs(32'h0F0F_0F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select data_4 (selector=100)", test_num);
            data_0 = 32'hDEAD_BEEF;
            data_1 = 32'hCAFE_BABE;
            data_2 = 32'hBEEF_CAFE;
            data_3 = 32'hFACE_FEED;
            data_4 = 32'h1337_C0DE;
            selector = 3'b100;
            #1;

            check_outputs(32'h1337_C0DE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Verify data change propagates for selector 0", test_num);
            data_0 = 32'h0000_0001;
            selector = 3'b000;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Verify data change propagates for selector 4", test_num);
            data_4 = 32'h8000_0000;
            selector = 3'b100;
            #1;

            check_outputs(32'h8000_0000);
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
        input [31:0] expected_mux_iord_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_iord_out === (expected_mux_iord_out ^ mux_iord_out ^ expected_mux_iord_out)) begin
                $display("PASS");
                $display("  Outputs: mux_iord_out=%h",
                         mux_iord_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_iord_out=%h",
                         expected_mux_iord_out);
                $display("  Got:      mux_iord_out=%h",
                         mux_iord_out);
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
