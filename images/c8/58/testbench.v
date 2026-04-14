`timescale 1ns/1ps

module mathOpModule_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg operation;
    wire [8:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mathOpModule dut (
        .a(a),
        .b(b),
        .operation(operation),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Addition (15 + 25)", test_num);
        a = 8'd15;
        b = 8'd25;
        operation = 1'b1;
        #1;

        check_outputs(9'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition with Carry/Overflow (200 + 100)", test_num);
        a = 8'd200;
        b = 8'd100;
        operation = 1'b1;
        #1;

        check_outputs(9'd300);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Maximum Addition (255 + 255)", test_num);
        a = 8'd255;
        b = 8'd255;
        operation = 1'b1;
        #1;

        check_outputs(9'd510);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Simple Subtraction (100 - 40)", test_num);
        a = 8'd100;
        b = 8'd40;
        operation = 1'b0;
        #1;

        check_outputs(9'd60);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction Resulting in Zero (128 - 128)", test_num);
        a = 8'd128;
        b = 8'd128;
        operation = 1'b0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Negative Subtraction / Wrap-around (10 - 20)", test_num);
        a = 8'd10;
        b = 8'd20;
        operation = 1'b0;


        #1;



        check_outputs(9'd502);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Edge Case - Minimum and Maximum (0 - 255)", test_num);
        a = 8'd0;
        b = 8'd255;
        operation = 1'b0;

        #1;


        check_outputs(9'd257);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Edge Case - Zero Addition (255 + 0)", test_num);
        a = 8'd255;
        b = 8'd0;
        operation = 1'b1;
        #1;

        check_outputs(9'd255);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mathOpModule Testbench");
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
        input [8:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
