`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] aluop;
    reg [5:0] func;
    wire [2:0] alucn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluop(aluop),
        .func(func),
        .alucn(alucn)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: aluop=00 (LW/SW) - Expected alucn=010", test_num);
            aluop = 2'b00;
            func = 6'b000000;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: aluop=01 (BEQ) - Expected alucn=110", test_num);
            aluop = 2'b01;
            func = 6'b000000;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: aluop=10, func=6'h20 (ADD) - Expected alucn=010", test_num);
            aluop = 2'b10;
            func = 6'h20;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: aluop=10, func=6'h22 (SUB) - Expected alucn=110", test_num);
            aluop = 2'b10;
            func = 6'h22;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: aluop=10, func=6'h24 (AND) - Expected alucn=000", test_num);
            aluop = 2'b10;
            func = 6'h24;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: aluop=10, func=6'h25 (OR) - Expected alucn=001", test_num);
            aluop = 2'b10;
            func = 6'h25;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: aluop=10, func=6'h2a (SLT) - Expected alucn=111", test_num);
            aluop = 2'b10;
            func = 6'h2a;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: aluop=00, check ignore func - Expected alucn=010", test_num);
            aluop = 2'b00;
            func = 6'h3f;
            #1;

            check_outputs(3'b010);
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
        input [2:0] expected_alucn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alucn === (expected_alucn ^ alucn ^ expected_alucn)) begin
                $display("PASS");
                $display("  Outputs: alucn=%h",
                         alucn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alucn=%h",
                         expected_alucn);
                $display("  Got:      alucn=%h",
                         alucn);
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
