`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i;
    reg [2:0] sel;
    wire o0;
    wire o1;
    wire o2;
    wire o3;
    wire o4;
    wire o5;
    wire o6;
    wire o7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .sel(sel),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .o5(o5),
        .o6(o6),
        .o7(o7)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: sel=000, i=1", test_num);
        sel = 3'b000; i = 1'b1;
        #10;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: sel=001, i=1", test_num);
        sel = 3'b001; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: sel=010, i=1", test_num);
        sel = 3'b010; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: sel=011, i=1", test_num);
        sel = 3'b011; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: sel=100, i=1", test_num);
        sel = 3'b100; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: sel=101, i=1", test_num);
        sel = 3'b101; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: sel=110, i=1", test_num);
        sel = 3'b110; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: sel=111, i=1", test_num);
        sel = 3'b111; i = 1'b1;
        #10;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: sel=000, i=0", test_num);
        sel = 3'b000; i = 1'b0;
        #10;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: sel=101, i=0", test_num);
        sel = 3'b101; i = 1'b0;
        #10;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input expected_o4;
        input expected_o5;
        input expected_o6;
        input expected_o7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4) &&
                expected_o5 === (expected_o5 ^ o5 ^ expected_o5) &&
                expected_o6 === (expected_o6 ^ o6 ^ expected_o6) &&
                expected_o7 === (expected_o7 ^ o7 ^ expected_o7)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b",
                         o0, o1, o2, o3, o4, o5, o6, o7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b",
                         expected_o0, expected_o1, expected_o2, expected_o3, expected_o4, expected_o5, expected_o6, expected_o7);
                $display("  Got:      o0=%b, o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b",
                         o0, o1, o2, o3, o4, o5, o6, o7);
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
