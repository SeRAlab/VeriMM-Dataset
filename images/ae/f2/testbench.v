`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] f;
    wire [10:0] clear_middle;
    wire [10:0] toggle_edges;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .clear_middle(clear_middle),
        .toggle_edges(toggle_edges)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            f = 11'h000;


            #1;



            check_outputs(11'h000, 11'h401);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones", test_num);
            f = 11'h7FF;


            #1;



            check_outputs(11'h7DF, 11'h3FE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only middle bit set", test_num);
            f = 11'h020;


            #1;



            check_outputs(11'h000, 11'h421);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Only edge bits set", test_num);
            f = 11'h401;


            #1;



            check_outputs(11'h401, 11'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Random pattern 1 (0x555)", test_num);
            f = 11'h555;


            #1;



            check_outputs(11'h555, 11'h154);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Random pattern 2 (0x2AA)", test_num);
            f = 11'h2AA;


            #1;



            check_outputs(11'h28A, 11'h6AB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Walking bit across middle and edges", test_num);
            f = 11'h021;


            #1;



            check_outputs(11'h001, 11'h420);
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
        input [10:0] expected_clear_middle;
        input [10:0] expected_toggle_edges;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clear_middle === (expected_clear_middle ^ clear_middle ^ expected_clear_middle) &&
                expected_toggle_edges === (expected_toggle_edges ^ toggle_edges ^ expected_toggle_edges)) begin
                $display("PASS");
                $display("  Outputs: clear_middle=%h, toggle_edges=%h",
                         clear_middle, toggle_edges);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clear_middle=%h, toggle_edges=%h",
                         expected_clear_middle, expected_toggle_edges);
                $display("  Got:      clear_middle=%h, toggle_edges=%h",
                         clear_middle, toggle_edges);
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
