`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in;
    wire [7:0] out_or;
    wire [7:0] out_sum;
    wire [8:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_or(out_or),
        .out_sum(out_sum),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 9'b000000000;
            #1;

            check_outputs(8'h00, 8'h00, 9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 9'b111111111;



            #1;




            check_outputs(8'hFF, 8'hFE, 9'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 9'b000000001;



            #1;




            check_outputs(8'h01, 8'h01, 9'h101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 9'b000000010;



            #1;




            check_outputs(8'h03, 8'h03, 9'h003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 9'b101010101;




            #1;





            check_outputs(8'hFF, 8'hFF, 9'h0FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 9'b010101010;




            #1;





            check_outputs(8'hFF, 8'hFF, 9'h0FF);
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
        input [7:0] expected_out_or;
        input [7:0] expected_out_sum;
        input [8:0] expected_out_xor;
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
