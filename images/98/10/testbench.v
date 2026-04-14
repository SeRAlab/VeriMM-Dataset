`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg c;
    reg control;
    reg select;
    wire [2:0] out_and_bitwise;
    wire out_and_logical;
    wire [3:0] out_mux;
    wire [5:0] out_not;
    wire [2:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .control(control),
        .select(select),
        .out_and_bitwise(out_and_bitwise),
        .out_and_logical(out_and_logical),
        .out_mux(out_mux),
        .out_not(out_not),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 3'b000; b = 3'b000; c = 0; control = 0; select = 0;
            #1;

            check_outputs(3'b000, 1'b0, 4'b0000, 6'b111111, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 3'b101; b = 3'b011; c = 0; control = 0; select = 1;
            #1;

            check_outputs(3'b001, 1'b1, 4'b0011, 6'b100010, 3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 3'b111; b = 3'b010; c = 1; control = 1; select = 0;
            #1;

            check_outputs(3'b010, 1'b1, 4'b0101, 6'b101000, 3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 3'b100; b = 3'b000; c = 0; control = 0; select = 0;
            #1;

            check_outputs(3'b000, 1'b0, 4'b0100, 6'b111011, 3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 3'b010; b = 3'b101; c = 1; control = 1; select = 1;


            #1;



            check_outputs(3'b000, 1'b1, 4'b0000, 6'b010101, 3'b111);
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
        input [2:0] expected_out_and_bitwise;
        input expected_out_and_logical;
        input [3:0] expected_out_mux;
        input [5:0] expected_out_not;
        input [2:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and_bitwise === (expected_out_and_bitwise ^ out_and_bitwise ^ expected_out_and_bitwise) &&
                expected_out_and_logical === (expected_out_and_logical ^ out_and_logical ^ expected_out_and_logical) &&
                expected_out_mux === (expected_out_mux ^ out_mux ^ expected_out_mux) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and_bitwise=%h, out_and_logical=%b, out_mux=%h, out_not=%h, out_xor=%h",
                         out_and_bitwise, out_and_logical, out_mux, out_not, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and_bitwise=%h, out_and_logical=%b, out_mux=%h, out_not=%h, out_xor=%h",
                         expected_out_and_bitwise, expected_out_and_logical, expected_out_mux, expected_out_not, expected_out_xor);
                $display("  Got:      out_and_bitwise=%h, out_and_logical=%b, out_mux=%h, out_not=%h, out_xor=%h",
                         out_and_bitwise, out_and_logical, out_mux, out_not, out_xor);
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
