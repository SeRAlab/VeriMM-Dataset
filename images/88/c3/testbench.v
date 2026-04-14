`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] S;
    reg [31:0] T;
    wire [31:0] qout;
    wire [31:0] rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .T(T),
        .qout(qout),
        .rem(rem)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple exact division (20 / 4)", test_num);
        S = 32'd20; T = 32'd4;
        #1;

        check_outputs(32'd5, 32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division with remainder (17 / 3)", test_num);
        S = 32'd17; T = 32'd3;
        #1;

        check_outputs(32'd5, 32'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dividend smaller than divisor (5 / 10)", test_num);
        S = 32'd5; T = 32'd10;
        #1;

        check_outputs(32'd0, 32'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dividend is zero (0 / 50)", test_num);
        S = 32'd0; T = 32'd50;
        #1;

        check_outputs(32'd0, 32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large 32-bit value divided by 1", test_num);
        S = 32'hFFFF_FFFF; T = 32'd1;
        #1;

        check_outputs(32'hFFFF_FFFF, 32'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large 32-bit value divided by 2", test_num);
        S = 32'hFFFF_FFFF; T = 32'd2;
        #1;

        check_outputs(32'h7FFF_FFFF, 32'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of 2 division", test_num);
        S = 32'h0001_0000; T = 32'd256;
        #1;

        check_outputs(32'd256, 32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Prime number division", test_num);
        S = 32'd997; T = 32'd31;
        #1;

        check_outputs(32'd32, 32'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max / Max", test_num);
        S = 32'hFFFF_FFFF; T = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'd1, 32'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large arbitrary division", test_num);
        S = 32'd1000000000; T = 32'd3;
        #1;

        check_outputs(32'd333333333, 32'd1);
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
        input [31:0] expected_qout;
        input [31:0] expected_rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_qout === (expected_qout ^ qout ^ expected_qout) &&
                expected_rem === (expected_rem ^ rem ^ expected_rem)) begin
                $display("PASS");
                $display("  Outputs: qout=%h, rem=%h",
                         qout, rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qout=%h, rem=%h",
                         expected_qout, expected_rem);
                $display("  Got:      qout=%h, rem=%h",
                         qout, rem);
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
