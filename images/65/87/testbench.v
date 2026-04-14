`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'h00;
        b = 8'h00;
        sel = 1'b0;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'h05;
        b = 8'h03;
        sel = 1'b0;

        #1;


        check_outputs(4'h8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'h0F;
        b = 8'h01;
        sel = 1'b0;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'hF2;
        b = 8'hA3;
        sel = 1'b0;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'h00;
        b = 8'h00;
        sel = 1'b1;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'h50;
        b = 8'h30;
        sel = 1'b1;

        #1;


        check_outputs(4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'hF0;
        b = 8'h20;
        sel = 1'b1;

        #1;


        check_outputs(4'h1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'h2F;
        b = 8'h3A;
        sel = 1'b1;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 8'hAA;
        b = 8'h55;
        sel = 1'b0;

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 8'hAA;
        b = 8'h55;
        sel = 1'b1;

        #1;


        check_outputs(4'hF);
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
        testcase009();
        testcase010();
        
        
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
