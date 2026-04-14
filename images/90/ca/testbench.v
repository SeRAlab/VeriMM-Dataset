`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .q(q)
    );
    task testcase001;

    begin
        a = 3'd0;
        $display("Testing a = 0");
        #1;

        check_outputs(16'he283);
    end
        endtask

    task testcase002;

    begin
        a = 3'd1;
        $display("Testing a = 1");
        #1;

        check_outputs(16'h9e34);
    end
        endtask

    task testcase003;

    begin
        a = 3'd2;
        $display("Testing a = 2");
        #1;

        check_outputs(16'hefeb);
    end
        endtask

    task testcase004;

    begin
        a = 3'd3;
        $display("Testing a = 3");
        #1;

        check_outputs(16'h48ce);
    end
        endtask

    task testcase005;

    begin
        a = 3'd4;
        $display("Testing a = 4");
        #1;

        check_outputs(16'h2d00);
    end
        endtask

    task testcase006;

    begin
        a = 3'd5;
        $display("Testing a = 5");
        #1;

        check_outputs(16'hf048);
    end
        endtask

    task testcase007;

    begin
        a = 3'd6;
        $display("Testing a = 6");
        #1;

        check_outputs(16'h4b9e);
    end
        endtask

    task testcase008;

    begin
        a = 3'd7;
        $display("Testing a = 7");
        #1;

        check_outputs(16'h6f3f);
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
        input [15:0] expected_q;
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
