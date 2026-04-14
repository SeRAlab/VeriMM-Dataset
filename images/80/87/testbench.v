`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg select;
    wire out;
    wire overflow;
    wire [8:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .select(select),
        .out(out),
        .overflow(overflow),
        .s(s)
    );
    task testcase001;

    begin
        a = 8'd10; b = 8'd20; select = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 9'd30);
    end
        endtask

    task testcase002;

    begin
        a = 8'hFF; b = 8'h01; select = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 9'h100);
    end
        endtask

    task testcase003;

    begin
        a = 8'h7F; b = 8'h01; select = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1, 9'h080);
    end
        endtask

    task testcase004;

    begin
        a = 8'h80; b = 8'hFF; select = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1, 9'h17F);
    end
        endtask

    task testcase005;

    begin
        a = 8'hAA; b = 8'h55; select = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 9'h0FF);
    end
        endtask

    task testcase006;

    begin
        a = 8'hFF; b = 8'hFF; select = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 9'h000);
    end
        endtask

    task testcase007;

    begin
        a = 8'hF0; b = 8'h0F; select = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 9'h0FF);
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
        input expected_out;
        input expected_overflow;
        input [8:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: out=%b, overflow=%b, s=%h",
                         out, overflow, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, overflow=%b, s=%h",
                         expected_out, expected_overflow, expected_s);
                $display("  Got:      out=%b, overflow=%b, s=%h",
                         out, overflow, s);
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
