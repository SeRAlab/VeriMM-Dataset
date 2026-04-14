`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ac;
    reg [7:0] bus;
    reg [6:0] select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ac(ac),
        .bus(bus),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        ac = 8'hFF; bus = 8'h12; select = OP_ZERO;
        $display("Test %0d: Arithmetic - Zero", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ac = 8'hAA; bus = 8'h55; select = OP_BUS;
        $display("Test %0d: Arithmetic - Copy Bus", test_num);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ac = 8'h10; bus = 8'h20; select = OP_ADD;
        $display("Test %0d: Arithmetic - Add (10 + 20)", test_num);
        #1;

        check_outputs(8'h30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ac = 8'h0F; bus = 8'hFF; select = OP_INC;
        $display("Test %0d: Arithmetic - Increment AC (0F + 1)", test_num);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ac = 8'h20; bus = 8'h05; select = OP_SUB;
        $display("Test %0d: Arithmetic - Subtract (20 - 05)", test_num);
        #1;

        check_outputs(8'h1B);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ac = 8'hF0; bus = 8'hCC; select = OP_AND;
        $display("Test %0d: Logical - AND (F0 & CC)", test_num);
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ac = 8'hAA; bus = 8'h55; select = OP_XOR;
        $display("Test %0d: Logical - XOR (AA ^ 55)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ac = 8'hA0; bus = 8'h05; select = OP_OR;
        $display("Test %0d: Logical - OR (A0 | 05)", test_num);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ac = 8'h55; bus = 8'h00; select = OP_NOT;
        $display("Test %0d: Logical - NOT (~55)", test_num);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ac = 8'hFF; bus = 8'h01; select = OP_ADD;
        $display("Test %0d: Edge Case - Addition Overflow (FF + 01)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        ac = 8'h00; bus = 8'h01; select = OP_SUB;
        $display("Test %0d: Edge Case - Subtraction Underflow (00 - 01)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        ac = 8'hFF; bus = 8'h00; select = OP_INC;
        $display("Test %0d: Edge Case - Increment FF", test_num);
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
