`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] op;
    reg reset;
    wire [3:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .reset(reset),
        .LED(LED)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase001: Reset Priority Check");
        reset = 1;
        A = 4'd10; B = 4'd5; op = 2'b00;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase002: Addition (5 + 3)");
        reset = 1; #10; reset = 0;
        A = 4'd5; B = 4'd3; op = 2'b00;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase003: Subtraction (12 - 4)");
        reset = 1; #10; reset = 0;
        A = 4'd12; B = 4'd4; op = 2'b01;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase004: Multiplication (2 * 4)");
        reset = 1; #10; reset = 0;
        A = 4'd2; B = 4'd4; op = 2'b10;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase005: Division (15 / 3)");
        reset = 1; #10; reset = 0;
        A = 4'd15; B = 4'd3; op = 2'b11;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase006: Division by Zero Error Handling");
        reset = 1; #10; reset = 0;
        A = 4'd10; B = 4'd0; op = 2'b11;


        #1;



        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase007: Addition Overflow (10 + 10)");
        reset = 1; #10; reset = 0;
        A = 4'd10; B = 4'd10; op = 2'b00;

        #1;


        check_outputs(4'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase008: Multiplication Overflow (5 * 4)");
        reset = 1; #10; reset = 0;
        A = 4'd5; B = 4'd4; op = 2'b10;

        #1;


        check_outputs(4'd4);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase009: Subtraction Underflow (2 - 5)");
        reset = 1; #10; reset = 0;
        A = 4'd2; B = 4'd5; op = 2'b01;

        #1;


        check_outputs(4'd13);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase010: Maximum Values Addition (15 + 15)");
        reset = 1; #10; reset = 0;
        A = 4'd15; B = 4'd15; op = 2'b00;

        #1;


        check_outputs(4'd14);
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
        input [3:0] expected_LED;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
