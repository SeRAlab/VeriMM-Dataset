`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire [8:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in1 = 8'h00;
            in2 = 8'h00;
            $display("Testcase %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in1 = 8'h05;
            in2 = 8'h0A;
            $display("Testcase %0d: Simple addition without carry (5 + 10)", test_num);
            #1;

            check_outputs(9'h00F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in1 = 8'hFF;
            in2 = 8'h01;
            $display("Testcase %0d: Carry out to bit 8 (255 + 1)", test_num);
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in1 = 8'hFF;
            in2 = 8'hFF;
            $display("Testcase %0d: Maximum possible sum (255 + 255)", test_num);
            #1;

            check_outputs(9'h1FE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in1 = 8'hAA;
            in2 = 8'h55;
            $display("Testcase %0d: Alternating bits (170 + 85)", test_num);
            #1;

            check_outputs(9'h0FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in1 = 8'h03;
            in2 = 8'h01;
            $display("Testcase %0d: Testing carry within the first 2-bit pair (3 + 1)", test_num);
            #1;

            check_outputs(9'h004);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in1 = 8'h0C;
            in2 = 8'h04;
            $display("Testcase %0d: Testing carry within the second 2-bit pair (12 + 4)", test_num);
            #1;

            check_outputs(9'h010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in1 = 8'hF0;
            in2 = 8'h10;
            $display("Testcase %0d: Testing carry across higher order pairs (240 + 16)", test_num);
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in1 = 8'h7F;
            in2 = 8'h7F;
            $display("Testcase %0d: Boundary check near max 7-bit (127 + 127)", test_num);
            #1;

            check_outputs(9'h0FE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in1 = 8'hD2;
            in2 = 8'h2E;
            $display("Testcase %0d: Random pattern addition (210 + 46)", test_num);
            #1;

            check_outputs(9'h100);
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
        input [8:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
