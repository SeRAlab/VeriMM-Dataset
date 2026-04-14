`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] inA;
    reg [7:0] inB;
    reg [7:0] inC;
    reg [7:0] inD;
    reg [1:0] select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inA(inA),
        .inB(inB),
        .inC(inC),
        .inD(inD),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A", test_num);
            inA = 8'hA1;
            inB = 8'hB2;
            inC = 8'hC3;
            inD = 8'hD4;
            select = 2'b00;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input B", test_num);
            inA = 8'hA1;
            inB = 8'hB2;
            inC = 8'hC3;
            inD = 8'hD4;
            select = 2'b01;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input C", test_num);
            inA = 8'hA1;
            inB = 8'hB2;
            inC = 8'hC3;
            inD = 8'hD4;
            select = 2'b10;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input D", test_num);
            inA = 8'hA1;
            inB = 8'hB2;
            inC = 8'hC3;
            inD = 8'hD4;
            select = 2'b11;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values (All FF/00)", test_num);
            inA = 8'hFF;
            inB = 8'h00;
            inC = 8'hAA;
            inD = 8'h55;
            select = 2'b00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switching select on same inputs", test_num);
            inA = 8'h10;
            inB = 8'h20;
            inC = 8'h30;
            inD = 8'h40;
            select = 2'b10;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check sensitivity to input change", test_num);
            inA = 8'h00;
            inB = 8'hEE;
            inC = 8'h00;
            inD = 8'h00;
            select = 2'b01;
            #5;
            inB = 8'h99;
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_out;
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
