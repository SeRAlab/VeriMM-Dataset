`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] e;
    reg [1:0] f;
    reg [1:0] g;
    wire [1:0] h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .f(f),
        .g(g),
        .h(h)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            e = 2'b00;
            f = 2'b00;
            g = 2'b00;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            e = 2'b11;
            f = 2'b11;
            g = 2'b11;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 0 is NANDed 0, Bit 1 is NANDed 1", test_num);
            e = 2'b01;
            f = 2'b11;
            g = 2'b11;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 0 is NANDed 1, Bit 1 is NANDed 0", test_num);
            e = 2'b10;
            f = 2'b11;
            g = 2'b11;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bits (all resulting in 1)", test_num);
            e = 2'b01;
            f = 2'b10;
            g = 2'b11;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only one input high per bit", test_num);
            e = 2'b11;
            f = 2'b00;
            g = 2'b00;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two inputs high per bit", test_num);
            e = 2'b11;
            f = 2'b11;
            g = 2'b00;


            #1;



            check_outputs(2'b11);
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
        input [1:0] expected_h;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: h=%h",
                         h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h",
                         expected_h);
                $display("  Got:      h=%h",
                         h);
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
