`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [16:0] res;

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
            $display("Testcase %0d: Zero inputs", test_num);
            in1 = 16'h0000;
            in2 = 16'h0000;
            #1;

            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition no carry", test_num);
            in1 = 16'h1234;
            in2 = 16'h1111;
            #1;

            check_outputs(17'h02345);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry out of first segment (bits 3-0)", test_num);
            in1 = 16'h000F;
            in2 = 16'h0001;
            #1;

            check_outputs(17'h00010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry out of second segment (bits 7-4)", test_num);
            in1 = 16'h00F0;
            in2 = 16'h0010;
            #1;

            check_outputs(17'h00100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry out of third segment (bits 11-8)", test_num);
            in1 = 16'h0F00;
            in2 = 16'h0100;
            #1;

            check_outputs(17'h01000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry out of fourth segment (bits 15-12) - Final Carry", test_num);
            in1 = 16'hF000;
            in2 = 16'h1000;
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ripple carry through all segments", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h0001;
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values", test_num);
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            #1;

            check_outputs(17'h1FFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits", test_num);
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random complex addition", test_num);
            in1 = 16'hA2C5;
            in2 = 16'h7D3B;

            #1;


            check_outputs(17'h12000);
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
        input [16:0] expected_res;
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
