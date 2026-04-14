`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sel;
    wire carry_out;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .a(a),
        .b(b),
        .sel(sel),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition 5 + 3", test_num);
        a = 4'd5;
        b = 4'd3;
        sel = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition 12 + 7 (Overflow)", test_num);
        a = 4'd12;
        b = 4'd7;
        sel = 1'b0;
        #1;

        check_outputs(1'b1, 4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition 7 + 8", test_num);
        a = 4'd7;
        b = 4'd8;
        sel = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition 15 + 15", test_num);
        a = 4'd15;
        b = 4'd15;
        sel = 1'b0;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction 10 - 4", test_num);
        a = 4'd10;
        b = 4'd4;
        sel = 1'b1;
        #1;

        check_outputs(1'b0, 4'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction 8 - 8", test_num);
        a = 4'd8;
        b = 4'd8;
        sel = 1'b1;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction 4 - 10 (Negative/Borrow)", test_num);
        a = 4'd4;
        b = 4'd10;
        sel = 1'b1;


        #1;



        check_outputs(1'b1, 4'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction 0 - 1", test_num);
        a = 4'd0;
        b = 4'd1;
        sel = 1'b1;


        #1;



        check_outputs(1'b1, 4'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input expected_carry_out;
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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
