`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    wire [14:0] out_or;
    wire [14:0] out_sum;
    wire [15:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .out_or(out_or),
        .out_sum(out_sum),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            b = 16'h0000;
            #1;

            #1;


            check_outputs(15'h0000, 15'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            b = 16'hFFFF;
            #1;



            #1;




            check_outputs(15'h7FFF, 15'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            b = 16'hAAAA;
            #1;



            #1;




            check_outputs(15'h7FFF, 15'h7FFE, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            b = 16'h5555;
            #1;



            #1;




            check_outputs(15'h7FFF, 15'h7FFE, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            b = 16'h0001;
            #1;



            #1;




            check_outputs(15'h0001, 15'h0002, 16'h8001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            b = 16'h8000;
            #1;



            #1;




            check_outputs(15'h4000, 15'h0000, 16'hC000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            b = 16'h1234;
            #1;



            #1;




            check_outputs(15'h1B3E, 15'h1B2E, 16'h365C);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            b = 16'hF0F0;
            #1;



            #1;




            check_outputs(15'h78F8, 15'h1110, 16'h1111);
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
        input [14:0] expected_out_or;
        input [14:0] expected_out_sum;
        input [15:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_or=%h, out_sum=%h, out_xor=%h",
                         out_or, out_sum, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or=%h, out_sum=%h, out_xor=%h",
                         expected_out_or, expected_out_sum, expected_out_xor);
                $display("  Got:      out_or=%h, out_sum=%h, out_xor=%h",
                         out_or, out_sum, out_xor);
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
