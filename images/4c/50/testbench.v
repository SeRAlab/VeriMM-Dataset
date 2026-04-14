`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] WriteData;
    reg [2:0] md_control;
    reg md_signal;
    reg [31:0] res_hi;
    reg [31:0] res_lo;
    wire [31:0] WriteData_final;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WriteData(WriteData),
        .md_control(md_control),
        .md_signal(md_signal),
        .res_hi(res_hi),
        .res_lo(res_lo),
        .WriteData_final(WriteData_final)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: md_signal=0 (Pass WriteData)", test_num);
            WriteData = 32'hAAAA_BBBB;
            res_hi    = 32'h1111_2222;
            res_lo    = 32'h3333_4444;
            md_signal = 1'b0;
            md_control = 3'b000;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: md_signal=1, md_control=110 (Select res_hi)", test_num);
            WriteData = 32'hFFFF_FFFF;
            res_hi    = 32'h1234_5678;
            res_lo    = 32'h8765_4321;
            md_signal = 1'b1;
            md_control = 3'b110;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: md_signal=1, md_control=000 (Select res_lo)", test_num);
            WriteData = 32'h0000_0000;
            res_hi    = 32'hDEAD_BEEF;
            res_lo    = 32'hCAFE_BABE;
            md_signal = 1'b1;
            md_control = 3'b000;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: md_signal=1, md_control=111 (Select res_lo - logic check)", test_num);
            WriteData = 32'h5555_AAAA;
            res_hi    = 32'hCCCC_DDDD;
            res_lo    = 32'hEEEE_FFFF;
            md_signal = 1'b1;
            md_control = 3'b111;
            #1;

            check_outputs(32'hEEEE_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: md_signal=0, md_control=110 (Ensure md_signal has priority)", test_num);
            WriteData = 32'h9999_8888;
            res_hi    = 32'h1111_1111;
            res_lo    = 32'h2222_2222;
            md_signal = 1'b0;
            md_control = 3'b110;
            #1;

            check_outputs(32'h9999_8888);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data edge case (All Zeros)", test_num);
            WriteData = 32'h0;
            res_hi    = 32'h0;
            res_lo    = 32'h0;
            md_signal = 1'b1;
            md_control = 3'b110;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data edge case (All Ones)", test_num);
            WriteData = 32'hFFFF_FFFF;
            res_hi    = 32'hFFFF_FFFF;
            res_lo    = 32'hFFFF_FFFF;
            md_signal = 1'b1;
            md_control = 3'b001;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_WriteData_final;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WriteData_final === (expected_WriteData_final ^ WriteData_final ^ expected_WriteData_final)) begin
                $display("PASS");
                $display("  Outputs: WriteData_final=%h",
                         WriteData_final);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WriteData_final=%h",
                         expected_WriteData_final);
                $display("  Got:      WriteData_final=%h",
                         WriteData_final);
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
