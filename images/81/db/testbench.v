`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_1;
    reg [1:0] input_2;
    reg input_3;
    reg input_4;
    reg input_5;
    reg input_6;
    reg input_7;
    reg input_8;
    wire output_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .input_3(input_3),
        .input_4(input_4),
        .input_5(input_5),
        .input_6(input_6),
        .input_7(input_7),
        .input_8(input_8),
        .output_1(output_1)
    );
    task testcase001;

    begin
        test_num = 1;
        input_1 = 4'd0;
        input_2 = 2'b11;
        input_3 = 1'b1; input_4 = 1'b1; input_5 = 1'b1;
        input_6 = 1'b1; input_7 = 1'b1; input_8 = 1'b1;
        $display("Test %0d: input_1=0, expect output_1=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input_1 = 4'd1;
        input_3 = 1'b1;
        $display("Test %0d: input_1=1, input_3=1, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input_1 = 4'd1;
        input_3 = 1'b0;
        $display("Test %0d: input_1=1, input_3=0, expect output_1=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input_1 = 4'd2;
        input_4 = 1'b1;
        $display("Test %0d: input_1=2, input_4=1, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input_1 = 4'd3;
        input_5 = 1'b1;
        $display("Test %0d: input_1=3, input_5=1, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input_1 = 4'd4;
        input_6 = 1'b1;
        $display("Test %0d: input_1=4, input_6=1, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        input_1 = 4'd5;
        input_7 = 1'b1;
        $display("Test %0d: input_1=5, input_7=1, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        input_1 = 4'd6;
        input_8 = 1'b1;
        $display("Test %0d: input_1=6, input_8=1, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        input_1 = 4'd7;
        input_2 = 2'b01;
        $display("Test %0d: input_1=7, input_2=2'b01, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        input_1 = 4'd7;
        input_2 = 2'b10;
        $display("Test %0d: input_1=7, input_2=2'b10, expect output_1=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        input_1 = 4'd8;
        input_2 = 2'b10;
        $display("Test %0d: input_1=8, input_2=2'b10, expect output_1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        input_1 = 4'd9;
        input_2 = 2'b11;
        input_3 = 1'b1; input_8 = 1'b1;
        $display("Test %0d: input_1=9 (Out of Range), expect output_1=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        input_1 = 4'd15;
        input_2 = 2'b11;
        input_3 = 1'b1;
        $display("Test %0d: input_1=15, expect output_1=0", test_num);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_output_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_1 === (expected_output_1 ^ output_1 ^ expected_output_1)) begin
                $display("PASS");
                $display("  Outputs: output_1=%b",
                         output_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_1=%b",
                         expected_output_1);
                $display("  Got:      output_1=%b",
                         output_1);
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
