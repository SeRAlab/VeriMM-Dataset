`timescale 1ns/1ps

module temperature_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] tempA;
    reg [3:0] tempB;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_comparator dut (
        .tempA(tempA),
        .tempB(tempB),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Equal (Min values)", test_num);
        tempA = 4'd0;
        tempB = 4'd0;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Equal (Max values)", test_num);
        tempA = 4'd15;
        tempB = 4'd15;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: A < B (General)", test_num);
        tempA = 4'd5;
        tempB = 4'd10;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: A > B (General)", test_num);
        tempA = 4'd12;
        tempB = 4'd3;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: A < B (Boundary check)", test_num);
        tempA = 4'd7;
        tempB = 4'd8;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: A > B (Boundary check)", test_num);
        tempA = 4'd8;
        tempB = 4'd7;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: A=0, B=15", test_num);
        tempA = 4'd0;
        tempB = 4'd15;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: A=15, B=0", test_num);
        tempA = 4'd15;
        tempB = 4'd0;
        $display("  Inputs: tempA=%d, tempB=%d", tempA, tempB);
        #1;

        check_outputs(2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_comparator Testbench");
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
        input [1:0] expected_result;
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
