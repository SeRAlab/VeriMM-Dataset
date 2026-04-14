`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    wire [1:0] out;
    wire [3:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out),
        .xor_out(xor_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Equality at zero", test_num);
        in1 = 4'b0000; in2 = 4'b0000;
        #1;

        check_outputs(2'b00, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Equality at max value", test_num);
        in1 = 4'b1111; in2 = 4'b1111;
        #1;

        check_outputs(2'b00, 4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: in1 > in2 simple", test_num);
        in1 = 4'b1000; in2 = 4'b0001;
        #1;

        check_outputs(2'b01, 4'b1001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: in2 > in1 simple", test_num);
        in1 = 4'b0010; in2 = 4'b0100;
        #1;

        check_outputs(2'b10, 4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: in1 max vs in2 min", test_num);
        in1 = 4'b1111; in2 = 4'b0000;
        #1;

        check_outputs(2'b01, 4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: in2 max vs in1 min", test_num);
        in1 = 4'b0000; in2 = 4'b1111;
        #1;

        check_outputs(2'b10, 4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Alternating bits A vs 5", test_num);
        in1 = 4'b1010; in2 = 4'b0101;
        #1;

        check_outputs(2'b01, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Closest value comparison", test_num);
        in1 = 4'b1010; in2 = 4'b1011;
        #1;

        check_outputs(2'b10, 4'b0001);
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
        input [1:0] expected_out;
        input [3:0] expected_xor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h, xor_out=%h",
                         out, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, xor_out=%h",
                         expected_out, expected_xor_out);
                $display("  Got:      out=%h, xor_out=%h",
                         out, xor_out);
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
