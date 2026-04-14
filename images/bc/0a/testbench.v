`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg s;
    wire [31:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s(s),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h11111111;
            b = 32'h22222222;
            s = 1'b0;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h11111111;
            b = 32'h22222222;
            s = 1'b1;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            s = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            s = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            s = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            s = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'hDEADBEEF;
            b = 32'hCAFEBABE;
            s = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'hDEADBEEF;
            b = 32'hCAFEBABE;
            s = 1'b1;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
