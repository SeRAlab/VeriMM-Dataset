`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sc;
    wire [15:0] ss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sc(sc),
        .ss(ss)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            a = 16'h0000; b = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            a = 16'hFFFF; b = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            a = 16'hFFFF; b = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            a = 16'h5555; b = 16'hAAAA;
            #1;

            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            a = 16'h0001; b = 16'h0001;
            #1;

            check_outputs(16'h0001, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            a = 16'h1234; b = 16'h5678;

            #1;


            check_outputs(16'h1230, 16'h444C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            a = 16'h7FFF; b = 16'h0001;

            #1;


            check_outputs(16'h0001, 16'h7FFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;

            a = 16'h8000; b = 16'h0001;

            #1;


            check_outputs(16'h0000, 16'h8001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;

            a = 16'h0F0F; b = 16'hF0F0;
            #1;

            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;

            a = 16'h1357; b = 16'h2468;

            #1;


            check_outputs(16'h0040, 16'h373F);
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
        input [15:0] expected_sc;
        input [15:0] expected_ss;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sc === (expected_sc ^ sc ^ expected_sc) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: sc=%h, ss=%h",
                         sc, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sc=%h, ss=%h",
                         expected_sc, expected_ss);
                $display("  Got:      sc=%h, ss=%h",
                         sc, ss);
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
