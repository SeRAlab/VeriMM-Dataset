`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] out_AND;
    wire [7:0] out_NOT;
    wire [7:0] out_OR;
    wire [7:0] out_XOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out_AND(out_AND),
        .out_NOT(out_NOT),
        .out_OR(out_OR),
        .out_XOR(out_XOR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            in1 = 8'h00;
            in2 = 8'h00;




            #1;





            check_outputs(8'h00, 8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            in1 = 8'hFF;
            in2 = 8'hFF;




            #1;





            check_outputs(8'hFF, 8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bit Patterns", test_num);
            in1 = 8'hAA;
            in2 = 8'h55;




            #1;





            check_outputs(8'h00, 8'h55, 8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Nibble Patterns", test_num);
            in1 = 8'hF0;
            in2 = 8'h3C;




            #1;





            check_outputs(8'h30, 8'h0F, 8'hFC, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Values", test_num);
            in1 = 8'h12;
            in2 = 8'h34;




            #1;





            check_outputs(8'h10, 8'hED, 8'h36, 8'h26);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Inverse Input 2", test_num);
            in1 = 8'hC3;
            in2 = 8'h3C;




            #1;





            check_outputs(8'h00, 8'h3C, 8'hFF, 8'hFF);
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
        input [7:0] expected_out_AND;
        input [7:0] expected_out_NOT;
        input [7:0] expected_out_OR;
        input [7:0] expected_out_XOR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_AND === (expected_out_AND ^ out_AND ^ expected_out_AND) &&
                expected_out_NOT === (expected_out_NOT ^ out_NOT ^ expected_out_NOT) &&
                expected_out_OR === (expected_out_OR ^ out_OR ^ expected_out_OR) &&
                expected_out_XOR === (expected_out_XOR ^ out_XOR ^ expected_out_XOR)) begin
                $display("PASS");
                $display("  Outputs: out_AND=%h, out_NOT=%h, out_OR=%h, out_XOR=%h",
                         out_AND, out_NOT, out_OR, out_XOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_AND=%h, out_NOT=%h, out_OR=%h, out_XOR=%h",
                         expected_out_AND, expected_out_NOT, expected_out_OR, expected_out_XOR);
                $display("  Got:      out_AND=%h, out_NOT=%h, out_OR=%h, out_XOR=%h",
                         out_AND, out_NOT, out_OR, out_XOR);
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
