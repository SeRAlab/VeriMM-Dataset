`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [6:0] s;

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
            a = 4'h0; b = 4'h0; c = 4'h0;

            #1;


            check_outputs(7'b1010101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'hA; b = 4'h0; c = 4'h0;

            #1;


            check_outputs(7'b0110010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'h0; b = 4'h5; c = 4'h0;

            #1;


            check_outputs(7'b0110011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'hF; b = 4'hF; c = 4'hF;

            #1;


            check_outputs(7'b1001010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'h1; b = 4'h2; c = 4'h3;

            #1;


            check_outputs(7'b1001010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'h0; b = 4'h0; c = 4'hF;

            #1;


            check_outputs(7'b1010101);
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
        input [6:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
