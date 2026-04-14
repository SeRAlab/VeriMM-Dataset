`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire c;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (No Carry Out)", test_num);
            a = 8'h05;
            b = 8'h0A;

            #1;


            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry Out", test_num);
            a = 8'hFF;
            b = 8'h01;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs", test_num);
            a = 8'h00;
            b = 8'h00;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values Addition", test_num);
            a = 8'hFF;
            b = 8'hFF;

            #1;


            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Case - Just below overflow", test_num);
            a = 8'h7F;
            b = 8'h80;

            #1;


            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Symmetric Carry Bit Propagation", test_num);
            a = 8'hAA;
            b = 8'h55;

            #1;


            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermediate Carry Propagation", test_num);
            a = 8'h0F;
            b = 8'h01;

            #1;


            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Value and Zero", test_num);
            a = 8'hE7;
            b = 8'h00;

            #1;


            check_outputs(1'b0, 8'hE7);
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
        input expected_c;
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c=%b, s=%h",
                         c, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, s=%h",
                         expected_c, expected_s);
                $display("  Got:      c=%b, s=%h",
                         c, s);
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
