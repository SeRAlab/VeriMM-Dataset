`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d_in;
    reg [7:0] out_in;
    wire d_out;
    wire [14:0] d_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_in(d_in),
        .out_in(out_in),
        .d_out(d_out),
        .d_out2(d_out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            d_in = 8'h00;
            out_in = 8'h00;
            #1;

            check_outputs(1'b0, 15'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            d_in = 8'hFF;
            out_in = 8'hFF;


            #1;



            check_outputs(1'b1, 15'h7FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB High", test_num);
            d_in = 8'h80;
            out_in = 8'h00;


            #1;



            check_outputs(1'b1, 15'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Low, Rest of d_in High", test_num);
            d_in = 8'h7F;
            out_in = 8'h00;


            #1;



            check_outputs(1'b0, 15'h7F00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Pattern A", test_num);
            d_in = 8'hA5;
            out_in = 8'h3C;



            #1;




            check_outputs(1'b1, 15'h253C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Pattern B", test_num);
            d_in = 8'h5A;
            out_in = 8'hC3;



            #1;




            check_outputs(1'b0, 15'h5AC3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Concatenation Boundary", test_num);
            d_in = 8'h01;
            out_in = 8'hFF;



            #1;




            check_outputs(1'b0, 15'h01FF);
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
        input expected_d_out;
        input [14:0] expected_d_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_d_out2 === (expected_d_out2 ^ d_out2 ^ expected_d_out2)) begin
                $display("PASS");
                $display("  Outputs: d_out=%b, d_out2=%h",
                         d_out, d_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%b, d_out2=%h",
                         expected_d_out, expected_d_out2);
                $display("  Got:      d_out=%b, d_out2=%h",
                         d_out, d_out2);
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
