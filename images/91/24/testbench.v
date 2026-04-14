`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cu_aluScr;
    reg [31:0] data2;
    reg [31:0] extenderOutputA;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cu_aluScr(cu_aluScr),
        .data2(data2),
        .extenderOutputA(extenderOutputA),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data2 (cu_aluScr = 0)", test_num);
            cu_aluScr = 1'b0;
            data2 = 32'hAAAA_5555;
            extenderOutputA = 32'h1234_5678;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select extenderOutputA (cu_aluScr = 1)", test_num);
            cu_aluScr = 1'b1;
            data2 = 32'hAAAA_5555;
            extenderOutputA = 32'h1234_5678;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros, select data2", test_num);
            cu_aluScr = 1'b0;
            data2 = 32'h0000_0000;
            extenderOutputA = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones, select extenderOutputA", test_num);
            cu_aluScr = 1'b1;
            data2 = 32'h0000_0000;
            extenderOutputA = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits, select data2", test_num);
            cu_aluScr = 1'b0;
            data2 = 32'h55AA_55AA;
            extenderOutputA = 32'hAA55_AA55;
            #1;

            check_outputs(32'h55AA_55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random values, select extenderOutputA", test_num);
            cu_aluScr = 1'b1;
            data2 = 32'hDEAD_BEEF;
            extenderOutputA = 32'hCAFE_BABE;
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
