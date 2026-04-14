`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] ctrl;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'sd42; b = 8'sd42; ctrl = 2'b00;
        $display("Test %0d: Equality Positive (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'sd-42; b = 8'sd-42; ctrl = 2'b00;
        $display("Test %0d: Equality Negative (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'sd42; b = 8'sd-42; ctrl = 2'b00;
        $display("Test %0d: Equality Unequal (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'sd100; b = 8'sd50; ctrl = 2'b01;
        $display("Test %0d: Greater Than Pos (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'sd-10; b = 8'sd-20; ctrl = 2'b01;
        $display("Test %0d: Greater Than Neg (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'sd1; b = 8'sd-1; ctrl = 2'b01;
        $display("Test %0d: Greater Than Cross (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'sd-50; b = 8'sd50; ctrl = 2'b01;
        $display("Test %0d: Greater Than False (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'sd10; b = 8'sd20; ctrl = 2'b10;
        $display("Test %0d: Less Than Pos (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 8'sd-100; b = 8'sd-50; ctrl = 2'b10;
        $display("Test %0d: Less Than Neg (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 8'sd-128; b = 8'sd127; ctrl = 2'b10;
        $display("Test %0d: Less Than Cross (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 8'sd50; b = 8'sd-50; ctrl = 2'b10;
        $display("Test %0d: Less Than False (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 8'sd127; b = 8'sd-128; ctrl = 2'b01;
        $display("Test %0d: Edge Case GT (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        a = 8'sd-128; b = 8'sd127; ctrl = 2'b10;
        $display("Test %0d: Edge Case LT (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        a = 8'sd0; b = 8'sd0; ctrl = 2'b00;
        $display("Test %0d: Zero Equality (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        a = 8'sd0; b = 8'sd-1; ctrl = 2'b01;
        $display("Test %0d: Zero GT (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        a = 8'sd-1; b = 8'sd0; ctrl = 2'b10;
        $display("Test %0d: Zero LT (a=%d, b=%d, ctrl=%b)", test_num, $signed(a), $signed(b), ctrl);
        #1;

        check_outputs(1'b1);
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
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
