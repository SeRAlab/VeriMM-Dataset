`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] exe_dest;
    reg exe_wb_en;
    reg [3:0] mem_dest;
    reg mem_wb_en;
    reg [3:0] src1;
    reg [3:0] src2;
    wire [1:0] forward1;
    wire [1:0] forward2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .exe_dest(exe_dest),
        .exe_wb_en(exe_wb_en),
        .mem_dest(mem_dest),
        .mem_wb_en(mem_wb_en),
        .src1(src1),
        .src2(src2),
        .forward1(forward1),
        .forward2(forward2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No hazards, no forwarding", test_num);
            en = 1; exe_wb_en = 1; mem_wb_en = 1;
            src1 = 4'h1; src2 = 4'h2;
            exe_dest = 4'h3; mem_dest = 4'h4;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forward from EXE to src1", test_num);
            en = 1; exe_wb_en = 1; mem_wb_en = 0;
            src1 = 4'h5; src2 = 4'h6;
            exe_dest = 4'h5; mem_dest = 4'h0;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forward from EXE to src2", test_num);
            en = 1; exe_wb_en = 1; mem_wb_en = 0;
            src1 = 4'h1; src2 = 4'hA;
            exe_dest = 4'hA; mem_dest = 4'h0;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forward from MEM to src1", test_num);
            en = 1; exe_wb_en = 0; mem_wb_en = 1;
            src1 = 4'hB; src2 = 4'hC;
            exe_dest = 4'h0; mem_dest = 4'hB;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forward from MEM to src2", test_num);
            en = 1; exe_wb_en = 0; mem_wb_en = 1;
            src1 = 4'h1; src2 = 4'h3;
            exe_dest = 4'hF; mem_dest = 4'h3;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EXE to src1, MEM to src2", test_num);
            en = 1; exe_wb_en = 1; mem_wb_en = 1;
            src1 = 4'h4; src2 = 4'h8;
            exe_dest = 4'h4; mem_dest = 4'h8;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority test (EXE wins over MEM)", test_num);
            en = 1; exe_wb_en = 1; mem_wb_en = 1;
            src1 = 4'h7; src2 = 4'h7;
            exe_dest = 4'h7; mem_dest = 4'h7;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding disabled via en signal", test_num);
            en = 0; exe_wb_en = 1; mem_wb_en = 1;
            src1 = 4'h2; src2 = 4'h2;
            exe_dest = 4'h2; mem_dest = 4'h2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write-back enables are low", test_num);
            en = 1; exe_wb_en = 0; mem_wb_en = 0;
            src1 = 4'h9; src2 = 4'h9;
            exe_dest = 4'h9; mem_dest = 4'h9;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both sources match MEM stage", test_num);
            en = 1; exe_wb_en = 0; mem_wb_en = 1;
            src1 = 4'hE; src2 = 4'hE;
            exe_dest = 4'h0; mem_dest = 4'hE;
            #1;

            check_outputs(2'b10, 2'b10);
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
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_forward1;
        input [1:0] expected_forward2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward1 === (expected_forward1 ^ forward1 ^ expected_forward1) &&
                expected_forward2 === (expected_forward2 ^ forward2 ^ expected_forward2)) begin
                $display("PASS");
                $display("  Outputs: forward1=%h, forward2=%h",
                         forward1, forward2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward1=%h, forward2=%h",
                         expected_forward1, expected_forward2);
                $display("  Got:      forward1=%h, forward2=%h",
                         forward1, forward2);
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
