`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    reg [31:0] y;
    wire [63:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Multiplication", test_num);
            x = 32'd0;
            y = 32'd0;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Multiplication (x=1)", test_num);
            x = 32'd1;
            y = 32'hA5A5A5A5;
            #1;

            check_outputs(64'h00000000A5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Values", test_num);
            x = 32'd12345;
            y = 32'd67890;
            #1;

            check_outputs(64'd838102050);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Values (Power of 2)", test_num);
            x = 32'h00010000;
            y = 32'h00010000;
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Unsigned Values", test_num);
            x = 32'hFFFFFFFF;
            y = 32'hFFFFFFFF;
            #1;

            check_outputs(64'hFFFFFFFF00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime Multiplication", test_num);
            x = 32'd104729;
            y = 32'd1299709;
            #1;

            check_outputs(64'd136117222861);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits", test_num);
            x = 32'hAAAAAAAA;
            y = 32'h55555555;
            #1;

            check_outputs(64'h38E38E3871C71C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary - MSB Set", test_num);
            x = 32'h80000000;
            y = 32'd2;
            #1;

            check_outputs(64'h0000000100000000);
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
        input [63:0] expected_z;
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
