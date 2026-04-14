`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] fl_n;
    wire [5:0] fl_mask;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fl_n(fl_n),
        .fl_mask(fl_mask)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b000 (0)", test_num);
            fl_n = 3'b000;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b001 (1)", test_num);
            fl_n = 3'b001;
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b010 (2)", test_num);
            fl_n = 3'b010;
            #1;

            check_outputs(6'b000100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b011 (3)", test_num);
            fl_n = 3'b011;
            #1;

            check_outputs(6'b001000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b100 (4)", test_num);
            fl_n = 3'b100;
            #1;

            check_outputs(6'b010000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b101 (5)", test_num);
            fl_n = 3'b101;
            #1;

            check_outputs(6'b100000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b110 (6) - Undefined individual bit, checking logic floor", test_num);
            fl_n = 3'b110;


            #1;



            check_outputs(6'b000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input fl_n = 3'b111 (7) - All bits HIGH", test_num);
            fl_n = 3'b111;
            #1;

            check_outputs(6'b111111);
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
        input [5:0] expected_fl_mask;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fl_mask === (expected_fl_mask ^ fl_mask ^ expected_fl_mask)) begin
                $display("PASS");
                $display("  Outputs: fl_mask=%h",
                         fl_mask);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fl_mask=%h",
                         expected_fl_mask);
                $display("  Got:      fl_mask=%h",
                         fl_mask);
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
