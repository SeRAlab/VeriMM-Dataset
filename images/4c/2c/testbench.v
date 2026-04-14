`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg in5;
    reg in6;
    reg in7;
    reg sel0;
    reg sel1;
    reg sel2;
    wire out0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .out0(out0)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in0, set in0 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b00000001;
        {sel2, sel1, sel0} = 3'b000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in1, set in1 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b00000010;
        {sel2, sel1, sel0} = 3'b001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in2, set in2 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b00000100;
        {sel2, sel1, sel0} = 3'b010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in3, set in3 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b00001000;
        {sel2, sel1, sel0} = 3'b011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in4, set in4 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b00010000;
        {sel2, sel1, sel0} = 3'b100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in5, set in5 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b00100000;
        {sel2, sel1, sel0} = 3'b101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in6, set in6 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b01000000;
        {sel2, sel1, sel0} = 3'b110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in7, set in7 to 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b10000000;
        {sel2, sel1, sel0} = 3'b111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in0, set in0 to 0 while others are 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b11111110;
        {sel2, sel1, sel0} = 3'b000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in7, set in7 to 0 while others are 1", test_num);
        {in7, in6, in5, in4, in3, in2, in1, in0} = 8'b01111111;
        {sel2, sel1, sel0} = 3'b111;
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
        input expected_out0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0)) begin
                $display("PASS");
                $display("  Outputs: out0=%b",
                         out0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%b",
                         expected_out0);
                $display("  Got:      out0=%b",
                         out0);
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
