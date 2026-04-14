`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] clk;
    reg sel;
    wire sys_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sel(sel),
        .sys_clk(sys_clk)
    );
    task testcase001;

    begin
        $display("Testcase 001: Selecting clk[0] - Input high");

        clk = 4'b0000;
        sel = 2'd0;
        #5;

        clk[0] = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Selecting clk[1] - Input high");

        clk = 4'b0000;
        sel = 2'd1;
        #5;

        clk[1] = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Selecting clk[2] - Input high");

        clk = 4'b0000;
        sel = 2'd2;
        #5;

        clk[2] = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Selecting clk[3] - Input high");

        clk = 4'b0000;
        sel = 2'd3;
        #5;

        clk[3] = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Selecting clk[0] - Verify isolation from other inputs (high)");

        clk = 4'b1110;
        sel = 2'd0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Selecting clk[3] - Verify isolation from other inputs (high)");

        clk = 4'b0111;
        sel = 2'd3;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Dynamic switching between clock sources");

        clk = 4'b1010;
        sel = 2'd1;
        #10;

        sel = 2'd2;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Dynamic switching - Target high");

        clk = 4'b1010;
        sel = 2'd2;
        #10;

        sel = 2'd3;
        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_sys_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sys_clk === (expected_sys_clk ^ sys_clk ^ expected_sys_clk)) begin
                $display("PASS");
                $display("  Outputs: sys_clk=%b",
                         sys_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sys_clk=%b",
                         expected_sys_clk);
                $display("  Got:      sys_clk=%b",
                         sys_clk);
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
