`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] c;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .q(q)
    );
    task testcase001;

    begin
        a = 4'd5; b = 4'd3; c = 2'd2;
        test_num = 1;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        a = 4'd12; b = 4'd6; c = 2'd2;
        test_num = 2;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        a = 4'd10; b = 4'd4; c = 2'd1;
        test_num = 3;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        a = 4'd2; b = 4'd5; c = 2'd1;
        test_num = 4;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase005;

    begin
        a = 4'b1100; b = 4'b1010; c = 2'd0;
        test_num = 5;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        a = 4'b0101; b = 4'b1010; c = 2'd0;
        test_num = 6;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        a = 4'b1111; b = 4'b1111; c = 2'd2;
        test_num = 7;
        #1;

        check_outputs(4'd14);
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
        input [3:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
