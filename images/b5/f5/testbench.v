`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg parity_type_in;
    wire out;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .parity_type_in(parity_type_in),
        .out(out),
        .p(p)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 4'b0000;
        parity_type_in = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 4'b0000;
        parity_type_in = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 4'b0001;
        parity_type_in = 1'b0;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 4'b0100;
        parity_type_in = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 4'b0011;
        parity_type_in = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 4'b1010;
        parity_type_in = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 4'b0111;
        parity_type_in = 1'b0;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 4'b1101;
        parity_type_in = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 4'b1111;
        parity_type_in = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 4'b1111;
        parity_type_in = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0);
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
        input expected_out;
        input expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: out=%b, p=%b",
                         out, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, p=%b",
                         expected_out, expected_p);
                $display("  Got:      out=%b, p=%b",
                         out, p);
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
