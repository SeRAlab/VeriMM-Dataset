`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg reset;
    wire [1:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .reset(reset),
        .out(out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Asserting Reset with active inputs", test_num);
        reset = 1;
        A = 4'hF; B = 4'hA; C = 4'h5; D = 4'h3;
        #10;
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input A active (Highest Priority)", test_num);
        reset = 1; #5; reset = 0;
        A = 4'b0001; B = 4'b0000; C = 4'b0000; D = 4'b0000;
        #10;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input B active, A is zero", test_num);
        reset = 1; #5; reset = 0;
        A = 4'b0000; B = 4'hC; C = 4'b0000; D = 4'b0000;
        #10;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input C active, A and B are zero", test_num);
        reset = 1; #5; reset = 0;
        A = 4'b0000; B = 4'b0000; C = 4'h7; D = 4'b0000;
        #10;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input D active, A, B, and C are zero", test_num);
        reset = 1; #5; reset = 0;
        A = 4'b0000; B = 4'b0000; C = 4'b0000; D = 4'h1;
        #10;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Inputs A and D active, A should win", test_num);
        reset = 1; #5; reset = 0;
        A = 4'h5; B = 4'h0; C = 4'h0; D = 4'hF;
        #10;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Inputs B and C active, B should win", test_num);
        reset = 1; #5; reset = 0;
        A = 4'h0; B = 4'h2; C = 4'h8; D = 4'h0;
        #10;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: All inputs zero", test_num);
        reset = 1; #5; reset = 0;
        A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
        #10;
        #1;

        check_outputs(out, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: All inputs non-zero, A wins", test_num);
        reset = 1; #5; reset = 0;
        A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
        #10;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Transitioning from C priority to D priority", test_num);
        reset = 1; #5; reset = 0;
        A = 4'h0; B = 4'h0; C = 4'hA; D = 4'h5; #10;
        A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h5;
        #10;
        #1;

        check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
