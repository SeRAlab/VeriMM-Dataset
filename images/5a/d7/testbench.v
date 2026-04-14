`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i_a;
    reg i_c;
    reg i_d;
    reg [7:0] i_m;
    reg i_s;
    wire [7:0] o_a;
    wire o_c;
    wire o_n;
    wire o_v;
    wire o_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .i_c(i_c),
        .i_d(i_d),
        .i_m(i_m),
        .i_s(i_s),
        .o_a(o_a),
        .o_c(o_c),
        .o_n(o_n),
        .o_v(o_v),
        .o_z(o_z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        i_a = 8'h05; i_m = 8'h02; i_c = 1'b0; i_d = 1'b0; i_s = 1'b0;
        #1;

        check_outputs(8'h07, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        i_a = 8'hFE; i_m = 8'h01; i_c = 1'b1; i_d = 1'b0; i_s = 1'b0;
        #1;

        check_outputs(8'h00, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        i_a = 8'h7F; i_m = 8'h01; i_c = 1'b0; i_d = 1'b0; i_s = 1'b0;
        #1;

        check_outputs(8'h80, 1'b0, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        i_a = 8'h80; i_m = 8'h80; i_c = 1'b0; i_d = 1'b0; i_s = 1'b0;
        #1;

        check_outputs(8'h00, 1'b1, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        i_a = 8'h05; i_m = 8'h02; i_c = 1'b1; i_d = 1'b0; i_s = 1'b1;
        #1;

        check_outputs(8'h03, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        i_a = 8'h05; i_m = 8'h02; i_c = 1'b0; i_d = 1'b0; i_s = 1'b1;
        #1;

        check_outputs(8'h02, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        i_a = 8'h02; i_m = 8'h05; i_c = 1'b1; i_d = 1'b0; i_s = 1'b1;
        #1;

        check_outputs(8'hFD, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        i_a = 8'h80; i_m = 8'h01; i_c = 1'b1; i_d = 1'b0; i_s = 1'b1;
        #1;

        check_outputs(8'h7F, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        i_a = 8'h09; i_m = 8'h01; i_c = 1'b0; i_d = 1'b1; i_s = 1'b0;
        #1;

        check_outputs(8'h10, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        i_a = 8'h99; i_m = 8'h01; i_c = 1'b0; i_d = 1'b1; i_s = 1'b0;
        #1;

        check_outputs(8'h00, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        i_a = 8'h10; i_m = 8'h01; i_c = 1'b1; i_d = 1'b1; i_s = 1'b1;
        #1;

        check_outputs(8'h09, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        i_a = 8'h00; i_m = 8'h01; i_c = 1'b1; i_d = 1'b1; i_s = 1'b1;
        #1;

        check_outputs(8'h99, 1'b0, 1'b1, 1'b0, 1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_o_a;
        input expected_o_c;
        input expected_o_n;
        input expected_o_v;
        input expected_o_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_a === (expected_o_a ^ o_a ^ expected_o_a) &&
                expected_o_c === (expected_o_c ^ o_c ^ expected_o_c) &&
                expected_o_n === (expected_o_n ^ o_n ^ expected_o_n) &&
                expected_o_v === (expected_o_v ^ o_v ^ expected_o_v) &&
                expected_o_z === (expected_o_z ^ o_z ^ expected_o_z)) begin
                $display("PASS");
                $display("  Outputs: o_a=%h, o_c=%b, o_n=%b, o_v=%b, o_z=%b",
                         o_a, o_c, o_n, o_v, o_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_a=%h, o_c=%b, o_n=%b, o_v=%b, o_z=%b",
                         expected_o_a, expected_o_c, expected_o_n, expected_o_v, expected_o_z);
                $display("  Got:      o_a=%h, o_c=%b, o_n=%b, o_v=%b, o_z=%b",
                         o_a, o_c, o_n, o_v, o_z);
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
