`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] h;
    wire [4:0] i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .i(i)
    );
    task testcase001;

        begin
            test_num = 1;
            h = 5'd0;
            $display("Test %0d: h=%d", test_num, h);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            h = 5'd1;
            $display("Test %0d: h=%d", test_num, h);
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            h = 5'd10;
            $display("Test %0d: h=%d", test_num, h);
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            h = 5'd11;
            $display("Test %0d: h=%d", test_num, h);

            #1;


            check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            h = 5'd16;
            $display("Test %0d: h=%d", test_num, h);

            #1;


            check_outputs(5'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            h = 5'd21;
            $display("Test %0d: h=%d", test_num, h);

            #1;


            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            h = 5'd31;
            $display("Test %0d: h=%d", test_num, h);

            #1;


            check_outputs(5'd29);
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
        input [4:0] expected_i;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i === (expected_i ^ i ^ expected_i)) begin
                $display("PASS");
                $display("  Outputs: i=%h",
                         i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i=%h",
                         expected_i);
                $display("  Got:      i=%h",
                         i);
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
