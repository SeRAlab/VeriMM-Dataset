`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'hA; b = 4'h5; c = 4'h3; d = 4'hF;
            sel = 2'b00;
            $display("Test %0d: Select input 'a' (sel=00)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'hA; b = 4'h5; c = 4'h3; d = 4'hF;
            sel = 2'b01;
            $display("Test %0d: Select input 'b' (sel=01)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'hA; b = 4'h5; c = 4'h3; d = 4'hF;
            sel = 2'b10;
            $display("Test %0d: Select input 'c' (sel=10)", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'hA; b = 4'h5; c = 4'h3; d = 4'hF;
            sel = 2'b11;
            $display("Test %0d: Select input 'd' (sel=11)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'b1111; b = 4'b0000; c = 4'b1111; d = 4'b0000;
            sel = 2'b01;
            $display("Test %0d: All zeros check (sel=01)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'b1111; b = 4'b0000; c = 4'b1111; d = 4'b0000;
            sel = 2'b10;
            $display("Test %0d: All ones check (sel=10)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'h1; b = 4'h2; c = 4'h4; d = 4'h8;
            sel = 2'b00;
            $display("Test %0d: Walking bit test (sel=00)", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'h1; b = 4'h2; c = 4'h4; d = 4'h8;
            sel = 2'b11;
            $display("Test %0d: Walking bit test (sel=11)", test_num);
            #1;

            check_outputs(4'h8);
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
        input [3:0] expected_out;
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
