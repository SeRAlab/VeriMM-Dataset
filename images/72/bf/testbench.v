`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] int_s0;
    reg [7:0] x;
    reg [7:0] y;
    wire [6:0] cout;
    wire s0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .int_s0(int_s0),
        .x(x),
        .y(y),
        .cout(cout),
        .s0(s0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Inputs that result in 0)", test_num);
            x = 8'h00;
            y = 8'hFF;
            int_s0 = 6'h00;

            #1;


            check_outputs(7'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values", test_num);
            x = 8'hFF;
            y = 8'hFF;
            int_s0 = 6'h3F;



            #1;




            check_outputs(7'h7E, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-out boundary", test_num);
            x = 8'h80;
            y = 8'h80;
            int_s0 = 6'h01;



            #1;




            check_outputs(7'h40, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits", test_num);
            x = 8'hAA;
            y = 8'h55;
            int_s0 = 6'h2A;


            #1;



            check_outputs(7'h2A, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Calculation", test_num);
            x = 8'hF0;
            y = 8'h0F;
            int_s0 = 6'h3F;

            #1;


            check_outputs(7'h3F, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XNOR validation", test_num);
            x = 8'hCC;
            y = 8'h33;
            int_s0 = 6'h15;

            #1;


            check_outputs(7'h15, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifted Values", test_num);
            x = 8'hFF;
            y = 8'hFF;
            int_s0 = 6'h00;



            #1;




            check_outputs(7'h3F, 1'b1);
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
        input [6:0] expected_cout;
        input expected_s0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s0 === (expected_s0 ^ s0 ^ expected_s0)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s0=%b",
                         cout, s0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s0=%b",
                         expected_cout, expected_s0);
                $display("  Got:      cout=%h, s0=%b",
                         cout, s0);
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
