`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] y;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros input", test_num);
        x = 8'h00;
        y = 8'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones input", test_num);
        x = 8'hFF;
        y = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Matching bits 0 and 2 (Group A matches)", test_num);
        x = 8'b00000101;
        y = 8'b00000101;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Matching bits 4 and 6 (Group B matches)", test_num);
        x = 8'b01010000;
        y = 8'b01010000;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Only one bit set in first pair group", test_num);
        x = 8'b00000011;
        y = 8'b00000001;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Matching bits 1 and 3 (Group A matches)", test_num);
        x = 8'b00001010;
        y = 8'b00001010;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Matching bits 5 and 7 (Group B matches)", test_num);
        x = 8'b10100000;
        y = 8'b10100000;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Complementary inputs (No AND bits set)", test_num);
        x = 8'hAA;
        y = 8'h55;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Bits set across different reduction paths (no group match)", test_num);
        x = 8'b00010001;
        y = 8'b00010001;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Edge case bits 2, 3, 4, 5 set", test_num);
        x = 8'b00111100;
        y = 8'b00111100;



        #1;




        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Full Group A coverage", test_num);
        x = 8'h0F;
        y = 8'h0F;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Full Group B coverage", test_num);
        x = 8'hF0;
        y = 8'hF0;

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
