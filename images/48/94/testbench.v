`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] Z;
    wire ovf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .Z(Z),
        .ovf(ovf)
    );
    task testcase001;

        begin
            a = 32'd5;
            b = 32'd10;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            a = 32'hFFFFFFF0;
            b = 32'h00000002;
            #1;

            check_outputs(32'hFFFFFFF2, 1'b0);
        end
        endtask

    task testcase003;

        begin
            a = 32'h7FFFFFFF;
            b = 32'h00000001;
            #1;

            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            a = 32'h80000000;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            a = 32'h40000000;
            b = 32'h40000000;
            #1;

            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            a = 32'h80000000;
            b = 32'h80000000;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            a = 32'h7FFFFFFF;
            b = 32'h80000001;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            a = 32'h00000000;
            b = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 1'b0);
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
        input [31:0] expected_Z;
        input expected_ovf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_ovf === (expected_ovf ^ ovf ^ expected_ovf)) begin
                $display("PASS");
                $display("  Outputs: Z=%h, ovf=%b",
                         Z, ovf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h, ovf=%b",
                         expected_Z, expected_ovf);
                $display("  Got:      Z=%h, ovf=%b",
                         Z, ovf);
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
