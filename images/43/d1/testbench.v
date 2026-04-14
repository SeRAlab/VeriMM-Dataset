`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg [4:0] c;
    reg [4:0] d;
    reg sel;
    wire [4:0] o;

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
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 5'b10101;
            b = 5'b00000;
            c = 5'b11111;
            d = 5'b01010;
            sel = 2'b00;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 5'b10101;
            b = 5'b01100;
            c = 5'b11111;
            d = 5'b01010;
            sel = 2'b01;
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 5'b10101;
            b = 5'b01100;
            c = 5'b10001;
            d = 5'b01010;
            sel = 2'b10;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 5'b10101;
            b = 5'b01100;
            c = 5'b10001;
            d = 5'b11110;
            sel = 2'b11;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 5'h00;
            b = 5'h1F;
            c = 5'h00;
            d = 5'h00;
            sel = 2'b01;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 5'h1F;
            b = 5'h1F;
            c = 5'h00;
            d = 5'h1F;
            sel = 2'b10;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
