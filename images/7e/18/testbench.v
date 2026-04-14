`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire [7:0] max_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .max_val(max_val)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is the maximum value", test_num);
        A = 8'd255; B = 8'd128; C = 8'd64;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: B is the maximum value", test_num);
        A = 8'd10; B = 8'd200; C = 8'd150;
        #1;

        check_outputs(8'd200);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: C is the maximum value", test_num);
        A = 8'd45; B = 8'd90; C = 8'd210;
        #1;

        check_outputs(8'd210);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All three inputs are equal", test_num);
        A = 8'd77; B = 8'd77; C = 8'd77;
        #1;

        check_outputs(8'd77);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B are equal and maximum", test_num);
        A = 8'd180; B = 8'd180; C = 8'd30;
        #1;

        check_outputs(8'd180);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: B and C are equal and maximum", test_num);
        A = 8'd5; B = 8'd240; C = 8'd240;
        #1;

        check_outputs(8'd240);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and C are equal and maximum", test_num);
        A = 8'd222; B = 8'd111; C = 8'd222;
        #1;

        check_outputs(8'd222);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum boundary values (all zeros)", test_num);
        A = 8'd0; B = 8'd0; C = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum boundary values (all 255)", test_num);
        A = 8'd255; B = 8'd255; C = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential values in ascending order", test_num);
        A = 8'd126; B = 8'd127; C = 8'd128;
        #1;

        check_outputs(8'd128);
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
        input [7:0] expected_max_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_val === (expected_max_val ^ max_val ^ expected_max_val)) begin
                $display("PASS");
                $display("  Outputs: max_val=%h",
                         max_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_val=%h",
                         expected_max_val);
                $display("  Got:      max_val=%h",
                         max_val);
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
