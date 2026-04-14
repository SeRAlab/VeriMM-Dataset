`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] i_0r0;
    reg [1:0] i_0r1;
    reg reset;
    wire i_0a;
    wire [1:0] o_0r0;
    wire [1:0] o_0r1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0r0(i_0r0),
        .i_0r1(i_0r1),
        .reset(reset),
        .i_0a(i_0a),
        .o_0r0(o_0r0),
        .o_0r1(o_0r1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Active Reset (Outputs should be 0)", test_num);

        reset = 1;
        i_0r0 = 2'b11;
        i_0r1 = 2'b11;
        #10;

        #1;


        check_outputs(1'b0, 2'b00, 2'b00);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, i_0r0 bit 0 active", test_num);

        reset = 1; #5; reset = 0;
        i_0r0 = 2'b01;
        i_0r1 = 2'b00;
        #10;

        #1;


        check_outputs(1'b1, 2'b01, 2'b00);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, i_0r0 bit 1 active", test_num);
        reset = 1; #5; reset = 0;
        i_0r0 = 2'b10;
        i_0r1 = 2'b00;
        #10;
        #1;

        check_outputs(1'b1, 2'b10, 2'b00);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, i_0r1 bit 0 active", test_num);
        reset = 1; #5; reset = 0;
        i_0r0 = 2'b00;
        i_0r1 = 2'b01;
        #10;
        #1;

        check_outputs(1'b1, 2'b00, 2'b01);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, i_0r1 bit 1 active", test_num);
        reset = 1; #5; reset = 0;
        i_0r0 = 2'b00;
        i_0r1 = 2'b10;
        #10;
        #1;

        check_outputs(1'b1, 2'b00, 2'b10);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, all inputs active", test_num);
        reset = 1; #5; reset = 0;
        i_0r0 = 2'b11;
        i_0r1 = 2'b11;
        #10;
        #1;

        check_outputs(1'b1, 2'b11, 2'b11);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, all inputs zero", test_num);
        reset = 1; #5; reset = 0;
        i_0r0 = 2'b00;
        i_0r1 = 2'b00;
        #10;
        #1;

        check_outputs(1'b0, 2'b00, 2'b00);
    end
    endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset De-asserted, mixed input pattern", test_num);
        reset = 1; #5; reset = 0;
        i_0r0 = 2'b10;
        i_0r1 = 2'b01;
        #10;
        #1;

        check_outputs(1'b1, 2'b10, 2'b01);
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
        input expected_i_0a;
        input [1:0] expected_o_0r0;
        input [1:0] expected_o_0r1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_0a === (expected_i_0a ^ i_0a ^ expected_i_0a) &&
                expected_o_0r0 === (expected_o_0r0 ^ o_0r0 ^ expected_o_0r0) &&
                expected_o_0r1 === (expected_o_0r1 ^ o_0r1 ^ expected_o_0r1)) begin
                $display("PASS");
                $display("  Outputs: i_0a=%b, o_0r0=%h, o_0r1=%h",
                         i_0a, o_0r0, o_0r1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_0a=%b, o_0r0=%h, o_0r1=%h",
                         expected_i_0a, expected_o_0r0, expected_o_0r1);
                $display("  Got:      i_0a=%b, o_0r0=%h, o_0r1=%h",
                         i_0a, o_0r0, o_0r1);
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
