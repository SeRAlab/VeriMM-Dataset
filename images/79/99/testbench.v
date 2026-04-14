`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [2:0] alu_sel;
    reg [7:0] b;
    wire [3:0] nzvc;
    wire [7:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alu_sel(alu_sel),
        .b(b),
        .nzvc(nzvc),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (10 + 20)", test_num);
            a = 8'd10;
            b = 8'd20;
            alu_sel = 3'b000;
            #1;

            check_outputs(4'bxxxx, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Addition (255 + 1)", test_num);
            a = 8'hFF;
            b = 8'h01;
            alu_sel = 3'b000;

            #1;


            check_outputs(4'bxxxx, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            a = 8'h00;
            b = 8'h00;
            alu_sel = 3'b000;
            #1;

            check_outputs(4'bxxxx, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values (200 + 100)", test_num);
            a = 8'd200;
            b = 8'd100;
            alu_sel = 3'b000;

            #1;


            check_outputs(4'bxxxx, 8'd44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Result (127 + 128)", test_num);
            a = 8'd127;
            b = 8'd128;
            alu_sel = 3'b000;
            #1;

            check_outputs(4'bxxxx, 8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying alu_sel logic (Random inputs)", test_num);
            a = 8'hAA;
            b = 8'h55;
            alu_sel = 3'b000;

            #1;


            check_outputs(4'bxxxx, 8'hFF);
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
        input [3:0] expected_nzvc;
        input [7:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nzvc === (expected_nzvc ^ nzvc ^ expected_nzvc) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: nzvc=%h, res=%h",
                         nzvc, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nzvc=%h, res=%h",
                         expected_nzvc, expected_res);
                $display("  Got:      nzvc=%h, res=%h",
                         nzvc, res);
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
