`timescale 1ns/1ps

module add_sub_16bit_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [15:0] minuend;
    reg [15:0] subtrahend;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_sub_16bit dut (
        .control(control),
        .minuend(minuend),
        .subtrahend(subtrahend),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 0 + 0", test_num);
        control = 1'b0;
        minuend = 16'h0000;
        subtrahend = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 1234 + 5678", test_num);
        control = 1'b0;
        minuend = 16'h1234;
        subtrahend = 16'h5678;
        #1;

        check_outputs(16'h1234 + 16'h5678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: FFFF + 1 (Wrap around)", test_num);
        control = 1'b0;
        minuend = 16'hFFFF;
        subtrahend = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: AAAA + 5555", test_num);
        control = 1'b0;
        minuend = 16'hAAAA;
        subtrahend = 16'h5555;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 10 - 5", test_num);
        control = 1'b1;
        minuend = 16'd10;
        subtrahend = 16'd5;
        #1;

        check_outputs(16'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: FFFF - FFFF", test_num);
        control = 1'b1;
        minuend = 16'hFFFF;
        subtrahend = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 0 - 1 (Wrap around)", test_num);
        control = 1'b1;
        minuend = 16'h0000;
        subtrahend = 16'h0001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: FFFF - 0001", test_num);
        control = 1'b1;
        minuend = 16'hFFFF;
        subtrahend = 16'h0001;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Control toggle check (Add)", test_num);
        minuend = 16'h1000;
        subtrahend = 16'h0100;
        control = 1'b0;
        #1;

        check_outputs(16'h1100);

        test_num = test_num + 1;
        $display("\nTestcase %0d: Control toggle check (Sub)", test_num);
        control = 1'b1;
        #1;

        check_outputs(16'h0F00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 8000 - 1", test_num);
        control = 1'b1;
        minuend = 16'h8000;
        subtrahend = 16'h0001;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_sub_16bit Testbench");
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
        input [15:0] expected_result;
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
