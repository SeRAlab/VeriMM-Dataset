`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire carry_out;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .a(a),
        .b(b),
        .sub(sub),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

        begin
            a = 4'd5; b = 4'd3; sub = 1'b0;
            test_num = test_num + 1;
            $display("Test %03d: Addition 5 + 3", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            a = 4'd12; b = 4'd5; sub = 1'b0;
            test_num = test_num + 1;
            $display("Test %03d: Addition 12 + 5 (Carry Expected)", test_num);
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            a = 4'd8; b = 4'd8; sub = 1'b0;
            test_num = test_num + 1;
            $display("Test %03d: Addition 8 + 8", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            a = 4'hf; b = 4'hf; sub = 1'b0;
            test_num = test_num + 1;
            $display("Test %03d: Addition 15 + 15", test_num);
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase005;

        begin
            a = 4'd10; b = 4'd4; sub = 1'b1;
            test_num = test_num + 1;
            $display("Test %03d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            a = 4'd7; b = 4'd7; sub = 1'b1;
            test_num = test_num + 1;
            $display("Test %03d: Subtraction 7 - 7", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            a = 4'd3; b = 4'd10; sub = 1'b1;
            test_num = test_num + 1;
            $display("Test %03d: Subtraction 3 - 10 (Borrow Expected)", test_num);

            #1;


            check_outputs(1'b1, 4'd9);
        end
        endtask

    task testcase008;

        begin
            a = 4'd0; b = 4'd1; sub = 1'b1;
            test_num = test_num + 1;
            $display("Test %03d: Subtraction 0 - 1", test_num);

            #1;


            check_outputs(1'b1, 4'hf);
        end
        endtask

    task testcase009;

        begin
            a = 4'd15; b = 4'd0; sub = 1'b0;
            test_num = test_num + 1;
            $display("Test %03d: Addition 15 + 0", test_num);
            #1;

            check_outputs(1'b0, 4'hf);
        end
        endtask

    task testcase010;

        begin
            a = 4'd12; b = 4'd0; sub = 1'b1;
            test_num = test_num + 1;
            $display("Test %03d: Subtraction 12 - 0", test_num);
            #1;

            check_outputs(1'b0, 4'd12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
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
