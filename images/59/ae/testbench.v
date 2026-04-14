`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [32:0] Dif;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Dif(Dif)
    );
    task testcase001;

    begin
        $display("\nRunning testcase001: 5 - 3");
        test_num = test_num + 1;
        A = 32'd5;
        B = 32'd3;
        #1;

        check_outputs(33'h000000002);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: 3 - 5");
        test_num = test_num + 1;
        A = 32'd3;
        B = 32'd5;

        #1;


        check_outputs(33'h1FFFFFFFE);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: 0 - 0");
        test_num = test_num + 1;
        A = 32'd0;
        B = 32'd0;
        #1;

        check_outputs(33'h000000000);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: FFFFFFFF - FFFFFFFF");
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #1;

        check_outputs(33'h000000000);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: 0 - 1");
        test_num = test_num + 1;
        A = 32'h00000000;
        B = 32'h00000001;

        #1;


        check_outputs(33'h1FFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: FFFFFFFF - 0");
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        #1;

        check_outputs(33'h0FFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: 0 - FFFFFFFF");
        test_num = test_num + 1;
        A = 32'h00000000;
        B = 32'hFFFFFFFF;

        #1;


        check_outputs(33'h100000001);
    end
        endtask

    task testcase008;

    begin
        $display("\nRunning testcase008: 80000000 - 7FFFFFFF");
        test_num = test_num + 1;
        A = 32'h80000000;
        B = 32'h7FFFFFFF;

        #1;


        check_outputs(33'h000000001);
    end
        endtask

    task testcase009;

    begin
        $display("\nRunning testcase009: 7FFFFFFF - 80000000");
        test_num = test_num + 1;
        A = 32'h7FFFFFFF;
        B = 32'h80000000;

        #1;


        check_outputs(33'h1FFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        $display("\nRunning testcase010: Random Large Subtraction");
        test_num = test_num + 1;
        A = 32'h12345678;
        B = 32'h00000001;
        #1;

        check_outputs(33'h012345677);
    end
        endtask

    task testcase011;

    begin
        $display("\nRunning testcase011: 1 - FFFFFFFF");
        test_num = test_num + 1;
        A = 32'h00000001;
        B = 32'hFFFFFFFF;

        #1;


        check_outputs(33'h100000002);
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
        testcase011();
        
        
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
        input [32:0] expected_Dif;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dif === (expected_Dif ^ Dif ^ expected_Dif)) begin
                $display("PASS");
                $display("  Outputs: Dif=%h",
                         Dif);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dif=%h",
                         expected_Dif);
                $display("  Got:      Dif=%h",
                         Dif);
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
