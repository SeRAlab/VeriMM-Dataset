`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_a;
    reg input_b;
    reg input_c;
    reg vgnd;
    reg vpwr;
    wire output_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_a(input_a),
        .input_b(input_b),
        .input_c(input_c),
        .vgnd(vgnd),
        .vpwr(vpwr),
        .output_x(output_x)
    );
    task testcase001;

    begin
        test_num = 1;
        vpwr = 1;
        vgnd = 0;
        input_a = 0; input_b = 0; input_c = 0;
        $display("Test Case %0d: input_a=0, input_b=0, input_c=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        vpwr = 1;
        vgnd = 0;
        input_a = 0; input_b = 0; input_c = 1;
        $display("Test Case %0d: input_a=0, input_b=0, input_c=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        vpwr = 1;
        vgnd = 0;
        input_a = 0; input_b = 1; input_c = 0;
        $display("Test Case %0d: input_a=0, input_b=1, input_c=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        vpwr = 1;
        vgnd = 0;
        input_a = 0; input_b = 1; input_c = 1;
        $display("Test Case %0d: input_a=0, input_b=1, input_c=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        vpwr = 1;
        vgnd = 0;
        input_a = 1; input_b = 0; input_c = 0;
        $display("Test Case %0d: input_a=1, input_b=0, input_c=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        vpwr = 1;
        vgnd = 0;
        input_a = 1; input_b = 0; input_c = 1;
        $display("Test Case %0d: input_a=1, input_b=0, input_c=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        vpwr = 1;
        vgnd = 0;
        input_a = 1; input_b = 1; input_c = 0;
        $display("Test Case %0d: input_a=1, input_b=1, input_c=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        vpwr = 1;
        vgnd = 0;
        input_a = 1; input_b = 1; input_c = 1;
        $display("Test Case %0d: input_a=1, input_b=1, input_c=1", test_num);
        #1;

        check_outputs(1'b0);
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
        input expected_output_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_x === (expected_output_x ^ output_x ^ expected_output_x)) begin
                $display("PASS");
                $display("  Outputs: output_x=%b",
                         output_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_x=%b",
                         expected_output_x);
                $display("  Got:      output_x=%b",
                         output_x);
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
