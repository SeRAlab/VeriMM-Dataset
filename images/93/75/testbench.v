`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=10, b=10 (Equal values)", test_num);
            a = 8'd10;
            b = 8'd10;


            #1;



            check_outputs(16'h000A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=20, b=5 (a > b)", test_num);
            a = 8'd20;
            b = 8'd5;


            #1;



            check_outputs(16'h0F05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=5, b=20 (a < b)", test_num);
            a = 8'd5;
            b = 8'd20;


            #1;



            check_outputs(16'h0F05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=255, b=0 (Max difference)", test_num);
            a = 8'd255;
            b = 8'd0;


            #1;



            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=0, b=255 (Swapped max difference)", test_num);
            a = 8'd0;
            b = 8'd255;


            #1;



            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=128, b=127 (Smallest non-zero difference)", test_num);
            a = 8'd128;
            b = 8'd127;


            #1;



            check_outputs(16'h017F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=255, b=254 (High range boundary)", test_num);
            a = 8'd255;
            b = 8'd254;


            #1;



            check_outputs(16'h01FE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=0, b=0 (Zero boundary)", test_num);
            a = 8'd0;
            b = 8'd0;


            #1;



            check_outputs(16'h0000);
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
        input [15:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
