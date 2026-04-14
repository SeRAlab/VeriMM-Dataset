`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d_addrselector;
    reg d_immonly;
    reg d_jr_or_exec;
    reg [3:0] d_raddr1;
    reg [3:0] d_raddr2;
    reg e_isLoad;
    reg [3:0] e_wreg;
    wire ifid_stall;
    wire pc_stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_addrselector(d_addrselector),
        .d_immonly(d_immonly),
        .d_jr_or_exec(d_jr_or_exec),
        .d_raddr1(d_raddr1),
        .d_raddr2(d_raddr2),
        .e_isLoad(e_isLoad),
        .e_wreg(e_wreg),
        .ifid_stall(ifid_stall),
        .pc_stall(pc_stall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No hazard - different registers", test_num);
            d_addrselector = 0;
            d_immonly      = 0;
            d_jr_or_exec   = 0;
            d_raddr1       = 4'd1;
            d_raddr2       = 4'd2;
            e_isLoad       = 1'b1;
            e_wreg         = 4'd3;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load-Use hazard on raddr1", test_num);
            d_addrselector = 0;
            d_immonly      = 0;
            d_jr_or_exec   = 0;
            d_raddr1       = 4'd5;
            d_raddr2       = 4'd6;
            e_isLoad       = 1'b1;
            e_wreg         = 4'd5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load-Use hazard on raddr2", test_num);
            d_addrselector = 0;
            d_immonly      = 0;
            d_jr_or_exec   = 0;
            d_raddr1       = 4'd1;
            d_raddr2       = 4'd8;
            e_isLoad       = 1'b1;
            e_wreg         = 4'd8;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Register match but not a Load instruction", test_num);
            d_addrselector = 0;
            d_immonly      = 0;
            d_jr_or_exec   = 0;
            d_raddr1       = 4'd4;
            d_raddr2       = 4'd2;
            e_isLoad       = 1'b0;
            e_wreg         = 4'd4;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Match on raddr2 but instruction is Immediate-only", test_num);
            d_addrselector = 0;
            d_immonly      = 1'b1;
            d_jr_or_exec   = 0;
            d_raddr1       = 4'd1;
            d_raddr2       = 4'd7;
            e_isLoad       = 1'b1;
            e_wreg         = 4'd7;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Hazard check on Register 0 (Should not stall)", test_num);
            d_addrselector = 0;
            d_immonly      = 0;
            d_jr_or_exec   = 0;
            d_raddr1       = 4'd0;
            d_raddr2       = 4'd0;
            e_isLoad       = 1'b1;
            e_wreg         = 4'd0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Load-Use hazard with Jump Register (raddr1 match)", test_num);
            d_addrselector = 0;
            d_immonly      = 0;
            d_jr_or_exec   = 1'b1;
            d_raddr1       = 4'd9;
            d_raddr2       = 4'd0;
            e_isLoad       = 1'b1;
            e_wreg         = 4'd9;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_ifid_stall;
        input expected_pc_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ifid_stall === (expected_ifid_stall ^ ifid_stall ^ expected_ifid_stall) &&
                expected_pc_stall === (expected_pc_stall ^ pc_stall ^ expected_pc_stall)) begin
                $display("PASS");
                $display("  Outputs: ifid_stall=%b, pc_stall=%b",
                         ifid_stall, pc_stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ifid_stall=%b, pc_stall=%b",
                         expected_ifid_stall, expected_pc_stall);
                $display("  Got:      ifid_stall=%b, pc_stall=%b",
                         ifid_stall, pc_stall);
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
