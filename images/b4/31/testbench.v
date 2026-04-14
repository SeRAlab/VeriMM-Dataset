`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dir;
    reg [7:0] in;
    reg [2:0] shift_amt;
    wire flag;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir(dir),
        .in(in),
        .shift_amt(shift_amt),
        .flag(flag),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Left Shift by 0", test_num);
        dir = 0;
        shift_amt = 3'd0;
        in = 8'hAA;
        #1;

        check_outputs(1'b0, 8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Right Shift by 0", test_num);
        dir = 1;
        shift_amt = 3'd0;
        in = 8'h55;
        #1;

        check_outputs(1'b0, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Left Shift by 1, carry=1", test_num);
        dir = 0;
        shift_amt = 3'd1;
        in = 8'h81;
        #1;

        check_outputs(1'b1, 8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Left Shift by 1, carry=0", test_num);
        dir = 0;
        shift_amt = 3'd1;
        in = 8'h7F;
        #1;

        check_outputs(1'b0, 8'hFE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Right Shift by 1, carry=1", test_num);
        dir = 1;
        shift_amt = 3'd1;
        in = 8'h81;
        #1;

        check_outputs(1'b1, 8'h40);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Right Shift by 1, carry=0", test_num);
        dir = 1;
        shift_amt = 3'd1;
        in = 8'hFE;
        #1;

        check_outputs(1'b0, 8'h7F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Left Shift by 4, carry=1 (from middle)", test_num);
        dir = 0;
        shift_amt = 3'd4;
        in = 8'h10;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest %0d: Right Shift by 4, carry=1 (from middle)", test_num);
        dir = 1;
        shift_amt = 3'd4;
        in = 8'h08;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest %0d: Left Shift by 7, carry=0", test_num);
        dir = 0;
        shift_amt = 3'd7;
        in = 8'h01;
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest %0d: Right Shift by 7, carry=0", test_num);
        dir = 1;
        shift_amt = 3'd7;
        in = 8'h80;
        #1;

        check_outputs(1'b0, 8'h01);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("\nTest %0d: Left Shift 3, all bits set", test_num);
        dir = 0;
        shift_amt = 3'd3;
        in = 8'hFF;
        #1;

        check_outputs(1'b1, 8'hF8);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("\nTest %0d: Right Shift 3, all bits set", test_num);
        dir = 1;
        shift_amt = 3'd3;
        in = 8'hFF;
        #1;

        check_outputs(1'b1, 8'h1F);
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
        input expected_flag;
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag === (expected_flag ^ flag ^ expected_flag) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: flag=%b, out=%h",
                         flag, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b, out=%h",
                         expected_flag, expected_out);
                $display("  Got:      flag=%b, out=%h",
                         flag, out);
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
