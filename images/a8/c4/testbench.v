`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [11:0] x;
    reg [11:0] y;
    wire [11:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Addition", test_num);
            ctrl = 2'b00;
            x = 12'h060;
            y = 12'h050;
            #1;

            check_outputs(12'h0B0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Sign Addition", test_num);
            ctrl = 2'b00;
            x = 12'h060;
            y = 12'hFE0;
            #1;

            check_outputs(12'h040);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Subtraction", test_num);
            ctrl = 2'b01;
            x = 12'h080;
            y = 12'h030;
            #1;

            check_outputs(12'h050);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Subtraction Result", test_num);
            ctrl = 2'b01;
            x = 12'hFC0;
            y = 12'h020;
            #1;

            check_outputs(12'hFA0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Multiplication", test_num);
            ctrl = 2'b10;
            x = 12'h080;
            y = 12'h060;
            #1;

            check_outputs(12'h0C0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Signed Multiplication", test_num);
            ctrl = 2'b10;
            x = 12'hF80;
            y = 12'h020;
            #1;

            check_outputs(12'hFC0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Division", test_num);
            ctrl = 2'b11;
            x = 12'h0C0;
            y = 12'h060;
            #1;

            check_outputs(12'h080);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Signed Division", test_num);
            ctrl = 2'b11;
            x = 12'hF00;
            y = 12'h080;
            #1;

            check_outputs(12'hF80);
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
        input [11:0] expected_z;
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
