`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] in;
    wire [20:0] out_and;
    wire [20:0] out_or;
    wire [21:0] out_xnor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xnor(out_xnor)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in = 22'h0;

        #1;


        check_outputs(21'h0, 21'h0, 22'h3FFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in = 22'h3FFFFF;

        #1;


        check_outputs(21'h1FFFFF, 21'h1FFFFF, 22'h3FFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in = 22'h2AAAAA;

        #1;


        check_outputs(21'h0, 21'h1FFFFF, 22'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in = 22'h155555;

        #1;


        check_outputs(21'h0, 21'h1FFFFF, 22'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in = 22'h000003;

        #1;


        check_outputs(21'h1, 21'h3, 22'h1FFFFD);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in = 22'h200001;

        #1;


        check_outputs(21'h0, 21'h400001, 22'h2FFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in = 22'h000001;

        #1;


        check_outputs(21'h0, 21'h1, 22'h1FFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in = 22'h200000;

        #1;


        check_outputs(21'h0, 21'h100000, 22'h0FFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        in = 22'h123456;



        #1;




        check_outputs(21'h001022, 21'h1B3E7F, 22'h24D182);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        in = 22'h35A9F0;


        #1;



        check_outputs(21'h1080F0, 21'h1FFDF8, 22'h1082F7);
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
        input [20:0] expected_out_and;
        input [20:0] expected_out_or;
        input [21:0] expected_out_xnor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h, out_xnor=%h",
                         out_and, out_or, out_xnor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h, out_xnor=%h",
                         expected_out_and, expected_out_or, expected_out_xnor);
                $display("  Got:      out_and=%h, out_or=%h, out_xnor=%h",
                         out_and, out_or, out_xnor);
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
