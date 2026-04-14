`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] vec;
    wire o0;
    wire o1;
    wire o2;
    wire o3;
    wire [3:0] outv;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .outv(outv),
        .parity(parity)
    );
    task testcase001;

    begin
        test_num = 1;
        vec = 4'b0000;

        #1;


        check_outputs(0, 0, 0, 0, 4'h0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        vec = 4'b0001;
        #1;

        check_outputs(1, 0, 0, 0, 4'h1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        vec = 4'b0010;
        #1;

        check_outputs(0, 1, 0, 0, 4'h2, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        vec = 4'b0100;
        #1;

        check_outputs(0, 0, 1, 0, 4'h4, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        vec = 4'b1000;
        #1;

        check_outputs(0, 0, 0, 1, 4'h8, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        vec = 4'b1010;
        #1;

        check_outputs(0, 1, 0, 1, 4'hA, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        vec = 4'b1011;
        #1;

        check_outputs(1, 1, 0, 1, 4'hB, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        vec = 4'b1111;
        #1;

        check_outputs(1, 1, 1, 1, 4'hF, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        vec = 4'b0110;
        #1;

        check_outputs(0, 1, 1, 0, 4'h6, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        vec = 4'b1101;
        #1;

        check_outputs(1, 0, 1, 1, 4'hD, 1);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input [3:0] expected_outv;
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, parity=%b",
                         o0, o1, o2, o3, outv, parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, parity=%b",
                         expected_o0, expected_o1, expected_o2, expected_o3, expected_outv, expected_parity);
                $display("  Got:      o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, parity=%b",
                         o0, o1, o2, o3, outv, parity);
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
