`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg signal;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .signal(signal),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 5'h0A;
            B = 5'h15;
            signal = 1'b0;
            #10;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 5'h0A;
            B = 5'h15;
            signal = 1'b1;
            #10;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 5'h1F;
            B = 5'h00;
            signal = 1'b0;
            #10;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 5'h00;
            B = 5'h1F;
            signal = 1'b1;
            #10;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 5'h12;
            B = 5'h09;
            signal = 1'b0;
            #10;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 5'h12;
            B = 5'h09;
            signal = 1'b1;
            #10;
            #1;

            check_outputs(5'h09);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 5'h05;
            B = 5'h00;
            signal = 1'b0;
            #5;
            B = 5'h1F;
            #5;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 5'h00;
            B = 5'h1A;
            signal = 1'b1;
            #5;
            A = 5'h1F;
            #5;
            #1;

            check_outputs(5'h1A);
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
        input [4:0] expected_out;
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
