`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] select_0;
    reg [31:0] select_1;
    reg [31:0] select_2;
    reg [1:0] selection;
    wire [31:0] OutAddress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .select_0(select_0),
        .select_1(select_1),
        .select_2(select_2),
        .selection(selection),
        .OutAddress(OutAddress)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select 0 (Basic Pattern)", test_num);
            select_0 = 32'hAAAA_AAAA;
            select_1 = 32'hBBBB_BBBB;
            select_2 = 32'hCCCC_CCCC;
            selection = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select 1 (Basic Pattern)", test_num);
            select_0 = 32'h1111_1111;
            select_1 = 32'h2222_2222;
            select_2 = 32'h3333_3333;
            selection = 2'b01;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select 2 (Basic Pattern)", test_num);
            select_0 = 32'hDEAD_BEEF;
            select_1 = 32'hCAFE_BABE;
            select_2 = 32'hFACE_FEED;
            selection = 2'b10;
            #1;

            check_outputs(32'hFACE_FEED);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select 0 (All Zeros/All Ones)", test_num);
            select_0 = 32'h0000_0000;
            select_1 = 32'hFFFF_FFFF;
            select_2 = 32'h5555_5555;
            selection = 2'b00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select 1 (All Zeros/All Ones)", test_num);
            select_0 = 32'h0000_0000;
            select_1 = 32'hFFFF_FFFF;
            select_2 = 32'h5555_5555;
            selection = 2'b01;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select 2 (Alternating Bits)", test_num);
            select_0 = 32'hF0F0_F0F0;
            select_1 = 32'h0F0F_0F0F;
            select_2 = 32'h55AA_55AA;
            selection = 2'b10;
            #1;

            check_outputs(32'h55AA_55AA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: High-order bits check", test_num);
            select_0 = 32'h8000_0000;
            select_1 = 32'h4000_0000;
            select_2 = 32'h2000_0000;
            selection = 2'b00;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Low-order bits check", test_num);
            select_0 = 32'h0000_0001;
            select_1 = 32'h0000_0002;
            select_2 = 32'h0000_0004;
            selection = 2'b01;
            #1;

            check_outputs(32'h0000_0002);
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
        input [31:0] expected_OutAddress;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OutAddress === (expected_OutAddress ^ OutAddress ^ expected_OutAddress)) begin
                $display("PASS");
                $display("  Outputs: OutAddress=%h",
                         OutAddress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OutAddress=%h",
                         expected_OutAddress);
                $display("  Got:      OutAddress=%h",
                         OutAddress);
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
