`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out_and;
    wire [7:0] out_or;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_and(out_and),
        .out_or(out_or)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            a = 8'h00;
            b = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Alternating Bits (Complementary)", test_num);
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Nibble Masking", test_num);
            a = 8'hF0;
            b = 8'h0F;
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Identity AND", test_num);
            a = 8'hA5;
            b = 8'hFF;
            #1;

            check_outputs(8'hA5, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Zero OR", test_num);
            a = 8'h3C;
            b = 8'h00;
            #1;

            check_outputs(8'h00, 8'h3C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Random Pattern 1", test_num);
            a = 8'h12;
            b = 8'h34;


            #1;



            check_outputs(8'h10, 8'h36);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random Pattern 2", test_num);
            a = 8'hC3;
            b = 8'h99;


            #1;



            check_outputs(8'h81, 8'hDB);
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
        input [7:0] expected_out_and;
        input [7:0] expected_out_or;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h",
                         out_and, out_or);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h",
                         expected_out_and, expected_out_or);
                $display("  Got:      out_and=%h, out_or=%h",
                         out_and, out_or);
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
