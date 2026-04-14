`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg [1:0] sel;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 00 (Pass Input A)", test_num);
            a = 2'b10;
            b = 2'b01;
            sel = 2'b00;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 00 (Pass Input A - all bits high)", test_num);
            a = 2'b11;
            b = 2'b00;
            sel = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 01 (Pass Input B)", test_num);
            a = 2'b11;
            b = 2'b10;
            sel = 2'b01;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 01 (Pass Input B - mixed bits)", test_num);
            a = 2'b00;
            b = 2'b01;
            sel = 2'b01;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 10 (Bitwise AND - identical)", test_num);
            a = 2'b11;
            b = 2'b11;
            sel = 2'b10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 10 (Bitwise AND - complementary)", test_num);
            a = 2'b10;
            b = 2'b01;
            sel = 2'b10;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 10 (Bitwise AND - partial overlap)", test_num);
            a = 2'b11;
            b = 2'b10;
            sel = 2'b10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 11 (Bitwise OR - zeros)", test_num);
            a = 2'b00;
            b = 2'b00;
            sel = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 11 (Bitwise OR - complementary)", test_num);
            a = 2'b10;
            b = 2'b01;
            sel = 2'b11;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector 11 (Bitwise OR - single bits)", test_num);
            a = 2'b01;
            b = 2'b01;
            sel = 2'b11;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case - switch selector rapidly (00 to 11)", test_num);
            a = 2'b10;
            b = 2'b01;
            sel = 2'b00; #5;
            sel = 2'b11;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify AND with zero input", test_num);
            a = 2'b11;
            b = 2'b00;
            sel = 2'b10;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_out;
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
