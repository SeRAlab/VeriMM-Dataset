`timescale 1ns/1ps

module Adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder dut (
        .a(a),
        .b(b),
        .op(op),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition", test_num);
            a = 32'd123;
            b = 32'd456;
            op = 2'b00;
            #1;

            check_outputs(32'd579);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            op = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction", test_num);
            a = 32'd1000;
            b = 32'd300;
            op = 2'b01;
            #1;

            check_outputs(32'd700);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow", test_num);
            a = 32'd0;
            b = 32'd1;
            op = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'hFFFF_0000;
            op = 2'b10;
            #1;

            check_outputs(32'hAAAA_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND Zero Result", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            op = 2'b10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            a = 32'hF0F0_F0F0;
            b = 32'h0F0F_0F0F;
            op = 2'b11;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR Identity", test_num);
            a = 32'h1234_5678;
            b = 32'h0000_0000;
            op = 2'b11;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Add Zero", test_num);
            a = 32'hDEADBEEF;
            b = 32'h00000000;
            op = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtract Identity", test_num);
            a = 32'h87654321;
            b = 32'h87654321;
            op = 2'b01;
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
        $display("Adder Testbench");
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
        input [31:0] expected_out;
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
