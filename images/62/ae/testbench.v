`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] op;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h55555555;
            b = 32'hAAAAAAAA;
            op = 3'b000;
            $display("Test %0d: XOR - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hFFFFFFFF;
            b = 32'h0F0F0F0F;
            op = 3'b001;
            $display("Test %0d: AND - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'h0F0F0F0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h12345678;
            b = 32'h87654321;
            op = 3'b010;
            $display("Test %0d: OR - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'h97755779);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFFFFFF;
            b = 32'hAAAAAAAA;
            op = 3'b011;
            $display("Test %0d: AND NOT - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            op = 3'b100;
            $display("Test %0d: Inverted XOR - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hF0F0F0F0;
            b = 32'h0F0F0F0F;
            op = 3'b101;
            $display("Test %0d: Inverted AND - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h00000000;
            b = 32'h00000000;
            op = 3'b110;
            $display("Test %0d: Inverted OR - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'hF0F0F0F0;
            b = 32'h0F0F0F0F;
            op = 3'b111;
            $display("Test %0d: Inverted AND NOT - a=%h, b=%h, op=%b", test_num, a, b, op);


            #1;



            check_outputs(32'h0F0F0F0F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'hDEADBEEF;
            b = 32'h00000000;
            op = 3'b000;
            $display("Test %0d: XOR with 0 - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            op = 3'b011;
            $display("Test %0d: AND NOT Boundary - a=%h, b=%h, op=%b", test_num, a, b, op);
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_o;
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
