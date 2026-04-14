`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA;
    reg [1:0] SHIFT;
    wire [3:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA(DATA),
        .SHIFT(SHIFT),
        .RESULT(RESULT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1010, SHIFT=00 (Right 0 bits)", test_num);
        DATA = 4'b1010;
        SHIFT = 2'b00;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1000, SHIFT=01 (Right 1 bit circular)", test_num);
        DATA = 4'b1000;
        SHIFT = 2'b01;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=0001, SHIFT=01 (Right 1 bit circular)", test_num);
        DATA = 4'b0001;
        SHIFT = 2'b01;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1100, SHIFT=10 (Right 2 bits circular)", test_num);
        DATA = 4'b1100;
        SHIFT = 2'b10;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1010, SHIFT=10 (Right 2 bits circular)", test_num);
        DATA = 4'b1010;
        SHIFT = 2'b10;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=0001, SHIFT=11 (Left 1 bit circular)", test_num);
        DATA = 4'b0001;
        SHIFT = 2'b11;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1000, SHIFT=11 (Left 1 bit circular)", test_num);
        DATA = 4'b1000;
        SHIFT = 2'b11;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=0110, SHIFT=11 (Left 1 bit circular)", test_num);
        DATA = 4'b0110;
        SHIFT = 2'b11;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1111, SHIFT=00 (Right 0 bits)", test_num);
        DATA = 4'b1111;
        SHIFT = 2'b00;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: DATA=1111, SHIFT=01 (Right 1 bit circular)", test_num);
        DATA = 4'b1111;
        SHIFT = 2'b01;
        #1;

        check_outputs(4'b1111);
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
        input [3:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
