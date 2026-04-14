`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg sel;
    wire [4:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select B (sel=0)", test_num);
            sel = 1'b0;
            a = 5'h0A;
            b = 5'h15;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A (sel=1)", test_num);
            sel = 1'b1;
            a = 5'h0A;
            b = 5'h15;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select B with boundaries", test_num);
            sel = 1'b0;
            a = 5'h1F;
            b = 5'h00;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A with boundaries", test_num);
            sel = 1'b1;
            a = 5'h1F;
            b = 5'h00;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit on A (sel=1)", test_num);
            sel = 1'b1;
            a = 5'h01;
            b = 5'h1E;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit on B (sel=0)", test_num);
            sel = 1'b0;
            a = 5'h1E;
            b = 5'h02;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary patterns (sel=1)", test_num);
            sel = 1'b1;
            a = 5'h12;
            b = 5'h0D;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary patterns (sel=0)", test_num);
            sel = 1'b0;
            a = 5'h12;
            b = 5'h0D;
            #1;

            check_outputs(5'h0D);
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
        input [4:0] expected_c;
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
