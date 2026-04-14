`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [31:0] out_and;
    wire [31:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            in = 32'h0000_0000;


            #1;



            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            in = 32'hFFFF_FFFF;


            #1;



            check_outputs(32'h0000FFFF, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complementary halves", test_num);
            in = 32'hAAAA_5555;


            #1;



            check_outputs(32'h00000000, 32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical non-zero halves", test_num);
            in = 32'h1234_1234;


            #1;



            check_outputs(32'h00001234, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern A", test_num);
            in = 32'h1234_5678;




            #1;





            check_outputs(32'h00001230, 32'h0000444C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One half zero, one half full", test_num);
            in = 32'h0000_FFFF;


            #1;



            check_outputs(32'h00000000, 32'h0000FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise shifted pattern", test_num);
            in = 32'h8000_0001;



            #1;




            check_outputs(32'h00000000, 32'h00008001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern B", test_num);
            in = 32'hF0F0_0F0F;


            #1;



            check_outputs(32'h00000000, 32'h0000FFFF);
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
        input [31:0] expected_out_and;
        input [31:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_xor=%h",
                         out_and, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_xor=%h",
                         expected_out_and, expected_out_xor);
                $display("  Got:      out_and=%h, out_xor=%h",
                         out_and, out_xor);
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
