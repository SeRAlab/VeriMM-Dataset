`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] M_reg_out;
    reg [31:0] W_Forward;
    reg selet;
    wire [31:0] WD_final;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M_reg_out(M_reg_out),
        .W_Forward(W_Forward),
        .selet(selet),
        .WD_final(WD_final)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select M_reg_out (selet=0)", test_num);
            M_reg_out = 32'h12345678;
            W_Forward = 32'h9ABCDEF0;
            selet = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select W_Forward (selet=1)", test_num);
            M_reg_out = 32'h12345678;
            W_Forward = 32'h9ABCDEF0;
            selet = 1'b1;
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All F's vs All 0's (selet=0)", test_num);
            M_reg_out = 32'hFFFFFFFF;
            W_Forward = 32'h00000000;
            selet = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All F's vs All 0's (selet=1)", test_num);
            M_reg_out = 32'hFFFFFFFF;
            W_Forward = 32'h00000000;
            selet = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bit patterns (selet=0)", test_num);
            M_reg_out = 32'hAAAAAAAA;
            W_Forward = 32'h55555555;
            selet = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bit patterns (selet=1)", test_num);
            M_reg_out = 32'hAAAAAAAA;
            W_Forward = 32'h55555555;
            selet = 1'b1;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_WD_final;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WD_final === (expected_WD_final ^ WD_final ^ expected_WD_final)) begin
                $display("PASS");
                $display("  Outputs: WD_final=%h",
                         WD_final);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WD_final=%h",
                         expected_WD_final);
                $display("  Got:      WD_final=%h",
                         WD_final);
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
