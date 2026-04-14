`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            x = 8'h00;
            y = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic addition (5 + 10)", test_num);
            x = 8'd5;
            y = 8'd10;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values with overflow (255 + 1)", test_num);
            x = 8'hFF;
            y = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones (255 + 255)", test_num);
            x = 8'hFF;
            y = 8'hFF;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (0xAA + 0x55)", test_num);
            x = 8'hAA;
            y = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed-range boundary (127 + 1)", test_num);
            x = 8'd127;
            y = 8'd1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random values (0x12 + 0x34)", test_num);
            x = 8'h12;
            y = 8'h34;
            #1;

            check_outputs(8'h46);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carrying across bits (0x0F + 0x01)", test_num);
            x = 8'h0F;
            y = 8'h01;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large value addition (0x80 + 0x7F)", test_num);
            x = 8'h80;
            y = 8'h7F;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Commutative check (10 + 5)", test_num);
            x = 8'd10;
            y = 8'd5;
            #1;

            check_outputs(8'd15);
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
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
