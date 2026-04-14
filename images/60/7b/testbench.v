`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [32:0] a;
    reg [32:0] b;
    wire [32:0] a_shift;
    wire [32:0] b_shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .a_shift(a_shift),
        .b_shift(b_shift)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            a = 33'h0;
            b = 33'h0;
            #1;

            check_outputs(33'h0, 33'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            a = 33'h1FFFFFFFF;
            b = 33'h1FFFFFFFF;


            #1;



            check_outputs(33'h1FFFFFFFF, 33'h1FFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a MSB rotation", test_num);
            a = 33'h100000000;
            b = 33'h0;


            #1;



            check_outputs(33'h000000001, 33'h000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: b_shift MSB from a[0]", test_num);
            a = 33'h000000001;
            b = 33'h0;


            #1;



            check_outputs(33'h000000002, 33'h100000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: b right shift check", test_num);
            a = 33'h0;
            b = 33'h1AAAAAAAA;


            #1;



            check_outputs(33'h000000000, 33'h0D5555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Patterns 1", test_num);
            a = 33'h0AAAAAAAA;
            b = 33'h0AAAAAAAA;



            #1;




            check_outputs(33'h155555554, 33'h055555555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Patterns 2", test_num);
            a = 33'h155555555;
            b = 33'h155555555;



            #1;




            check_outputs(33'h0AAAAAAAB, 33'h1AAAAAAAA);
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
        input [32:0] expected_a_shift;
        input [32:0] expected_b_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_shift === (expected_a_shift ^ a_shift ^ expected_a_shift) &&
                expected_b_shift === (expected_b_shift ^ b_shift ^ expected_b_shift)) begin
                $display("PASS");
                $display("  Outputs: a_shift=%h, b_shift=%h",
                         a_shift, b_shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_shift=%h, b_shift=%h",
                         expected_a_shift, expected_b_shift);
                $display("  Got:      a_shift=%h, b_shift=%h",
                         a_shift, b_shift);
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
