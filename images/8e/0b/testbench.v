`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg o;
    wire [3:0] n;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .o(o),
        .n(n),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'h1;
        b = 4'h2;
        o = 1'b0;

        #1;


        check_outputs(4'h3, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'h5;
        b = 4'h3;
        o = 1'b1;

        #1;


        check_outputs(4'h9, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'hF;
        b = 4'h0;
        o = 1'b0;

        #1;


        check_outputs(4'hF, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'hF;
        b = 4'h0;
        o = 1'b1;

        #1;


        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'h8;
        b = 4'h8;
        o = 1'b0;

        #1;


        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'hF;
        b = 4'hF;
        o = 1'b1;

        #1;


        check_outputs(4'hF, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'hA;
        b = 4'h5;
        o = 1'b0;

        #1;


        check_outputs(4'hF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'hA;
        b = 4'h5;
        o = 1'b1;

        #1;


        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'h7;
        b = 4'h8;
        o = 1'b1;

        #1;


        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'h0;
        b = 4'h0;
        o = 1'b0;

        #1;


        check_outputs(4'h0, 1'b0);
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
        input [3:0] expected_n;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n === (expected_n ^ n ^ expected_n) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: n=%h, z=%b",
                         n, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%h, z=%b",
                         expected_n, expected_z);
                $display("  Got:      n=%h, z=%b",
                         n, z);
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
