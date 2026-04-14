`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [31:0] i_dat0;
    reg [31:0] i_dat1;
    wire [31:0] o_dat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .i_dat0(i_dat0),
        .i_dat1(i_dat1),
        .o_dat(o_dat)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select i_dat0 (Basic values)", test_num);
            i_dat0 = 32'hAAAA_BBBB;
            i_dat1 = 32'hCCCC_DDDD;
            control = 1'b0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select i_dat1 (Basic values)", test_num);
            i_dat0 = 32'hAAAA_BBBB;
            i_dat1 = 32'hCCCC_DDDD;
            control = 1'b1;
            #1;

            check_outputs(32'hCCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select i_dat0 (All 1s vs All 0s)", test_num);
            i_dat0 = 32'hFFFF_FFFF;
            i_dat1 = 32'h0000_0000;
            control = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select i_dat1 (All 1s vs All 0s)", test_num);
            i_dat0 = 32'hFFFF_FFFF;
            i_dat1 = 32'h0000_0000;
            control = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits pattern i_dat0", test_num);
            i_dat0 = 32'h5555_5555;
            i_dat1 = 32'hAAAA_AAAA;
            control = 1'b0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits pattern i_dat1", test_num);
            i_dat0 = 32'h5555_5555;
            i_dat1 = 32'hAAAA_AAAA;
            control = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking 1s check", test_num);
            i_dat0 = 32'h8000_0000;
            i_dat1 = 32'h0000_0001;
            control = 1'b0;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random-style Hex check", test_num);
            i_dat0 = 32'hDEAD_BEEF;
            i_dat1 = 32'hCAFE_BABE;
            control = 1'b1;
            #1;

            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_o_dat;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_dat === (expected_o_dat ^ o_dat ^ expected_o_dat)) begin
                $display("PASS");
                $display("  Outputs: o_dat=%h",
                         o_dat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dat=%h",
                         expected_o_dat);
                $display("  Got:      o_dat=%h",
                         o_dat);
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
