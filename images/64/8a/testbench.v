`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [15:0] in_a;
    reg [15:0] in_b;
    reg op;
    wire n;
    wire [15:0] out;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in_a(in_a),
        .in_b(in_b),
        .op(op),
        .n(n),
        .out(out),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 0; op = 2'b00; in_a = 16'hAAAA; in_b = 16'h5555;
            #1;

            check_outputs(1'b0, 16'h5555, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 1; op = 2'b00; in_a = 16'd100; in_b = 16'd250;
            #1;

            check_outputs(1'b0, 16'd350, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1; op = 2'b00; in_a = 16'hFFFF; in_b = 16'h0001;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1; op = 2'b00; in_a = 16'h7000; in_b = 16'h1000;
            #1;

            check_outputs(1'b1, 16'h8000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 1; op = 2'b01; in_a = 16'd500; in_b = 16'd100;
            #1;

            check_outputs(1'b0, 16'd400, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1; op = 2'b01; in_a = 16'd10; in_b = 16'd20;
            #1;

            check_outputs(1'b1, 16'hFFF6, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1; op = 2'b10; in_a = 16'hF0F0; in_b = 16'hAAAA;
            #1;

            check_outputs(1'b1, 16'hA0A0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            enable = 1; op = 2'b11; in_a = 16'h0010; in_b = 16'd2;
            #1;

            check_outputs(1'b0, 16'h0004, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            enable = 1; op = 2'b11; in_a = 16'h8000; in_b = 16'd1;
            #1;

            check_outputs(1'b1, 16'hC000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            enable = 1; op = 2'b10; in_a = 16'h0000; in_b = 16'hFFFF;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b1);
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
        input expected_n;
        input [15:0] expected_out;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n === (expected_n ^ n ^ expected_n) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: n=%b, out=%h, z=%b",
                         n, out, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b, out=%h, z=%b",
                         expected_n, expected_out, expected_z);
                $display("  Got:      n=%b, out=%h, z=%b",
                         n, out, z);
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
