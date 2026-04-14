`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] ra;
    wire [3:0] rb;
    wire [3:0] rc;
    wire [3:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .ra(ra),
        .rb(rb),
        .rc(rc),
        .rd(rd)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Already sorted input (1, 2, 3, 4)", test_num);
        a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
        #1;

        check_outputs(4'd1, 4'd2, 4'd3, 4'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Reverse sorted input (15, 10, 5, 0)", test_num);
        a = 4'd15; b = 4'd10; c = 4'd5; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd5, 4'd10, 4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: All values identical", test_num);
        a = 4'd7; b = 4'd7; c = 4'd7; d = 4'd7;
        #1;

        check_outputs(4'd7, 4'd7, 4'd7, 4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Two pairs of duplicates", test_num);
        a = 4'd3; b = 4'd12; c = 4'd3; d = 4'd12;
        #1;

        check_outputs(4'd3, 4'd3, 4'd12, 4'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Random permutation 1", test_num);
        a = 4'd8; b = 4'd2; c = 4'd11; d = 4'd5;
        #1;

        check_outputs(4'd2, 4'd5, 4'd8, 4'd11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Minimum and maximum bounds", test_num);
        a = 4'd15; b = 4'd0; c = 4'd15; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd15, 4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Single outlier (Large)", test_num);
        a = 4'd1; b = 4'd2; c = 4'd14; d = 4'd3;
        #1;

        check_outputs(4'd1, 4'd2, 4'd3, 4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Single outlier (Small)", test_num);
        a = 4'd12; b = 4'd13; c = 4'd1; d = 4'd11;
        #1;

        check_outputs(4'd1, 4'd11, 4'd12, 4'd13);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Triple duplicates", test_num);
        a = 4'd9; b = 4'd9; c = 4'd2; d = 4'd9;
        #1;

        check_outputs(4'd2, 4'd9, 4'd9, 4'd9);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Random permutation 2", test_num);
        a = 4'd4; b = 4'd6; c = 4'd5; d = 4'd3;
        #1;

        check_outputs(4'd3, 4'd4, 4'd5, 4'd6);
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
        input [3:0] expected_ra;
        input [3:0] expected_rb;
        input [3:0] expected_rc;
        input [3:0] expected_rd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ra === (expected_ra ^ ra ^ expected_ra) &&
                expected_rb === (expected_rb ^ rb ^ expected_rb) &&
                expected_rc === (expected_rc ^ rc ^ expected_rc) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: ra=%h, rb=%h, rc=%h, rd=%h",
                         ra, rb, rc, rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ra=%h, rb=%h, rc=%h, rd=%h",
                         expected_ra, expected_rb, expected_rc, expected_rd);
                $display("  Got:      ra=%h, rb=%h, rc=%h, rd=%h",
                         ra, rb, rc, rd);
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
