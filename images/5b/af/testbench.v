`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i1;
    reg i2;
    reg i3;
    reg i4;
    reg i5;
    reg i6;
    reg i7;
    reg i8;
    wire a1;
    wire s1;
    wire s2;
    wire s3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .i6(i6),
        .i7(i7),
        .i8(i8),
        .a1(a1),
        .s1(s1),
        .s2(s2),
        .s3(s3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs LOW -> State {s1,s2} = 00", test_num);
        i1=0; i2=0; i3=0; i4=0; i5=0; i6=0; i7=0; i8=0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: i1 HIGH -> State {s1,s2} = 10", test_num);
        i1=1; i2=0; i3=0; i4=0; i5=0; i6=0; i7=0; i8=0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: i5 HIGH -> State {s1,s2} = 01", test_num);
        i1=0; i2=0; i3=0; i4=0; i5=1; i6=0; i7=0; i8=0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: i1 and i5 HIGH -> State {s1,s2} = 11", test_num);
        i1=1; i2=0; i3=0; i4=0; i5=1; i6=0; i7=0; i8=0;


        #1;



        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Multiple s1 inputs -> State {s1,s2} = 10", test_num);
        i1=1; i2=1; i3=1; i4=1; i5=0; i6=0; i7=0; i8=0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Multiple s2 inputs -> State {s1,s2} = 01", test_num);
        i1=0; i2=0; i3=0; i4=0; i5=1; i6=1; i7=1; i8=1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Mixed inputs -> State {s1,s2} = 11", test_num);
        i1=0; i2=0; i3=0; i4=1; i5=0; i6=0; i7=0; i8=1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: All inputs HIGH -> State {s1,s2} = 11", test_num);
        {i1, i2, i3, i4, i5, i6, i7, i8} = 8'hFF;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
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
        input expected_a1;
        input expected_s1;
        input expected_s2;
        input expected_s3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a1 === (expected_a1 ^ a1 ^ expected_a1) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3)) begin
                $display("PASS");
                $display("  Outputs: a1=%b, s1=%b, s2=%b, s3=%b",
                         a1, s1, s2, s3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a1=%b, s1=%b, s2=%b, s3=%b",
                         expected_a1, expected_s1, expected_s2, expected_s3);
                $display("  Got:      a1=%b, s1=%b, s2=%b, s3=%b",
                         a1, s1, s2, s3);
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
