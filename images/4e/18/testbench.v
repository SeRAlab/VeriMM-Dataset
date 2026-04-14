`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [1:0] op;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .op(op),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        op = 2'b00; A = 4'h1; B = 4'h2; C = 4'h3;
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op = 2'b00; A = 4'hF; B = 4'h2; C = 4'h1;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op = 2'b01; A = 4'hA; B = 4'h3; C = 4'h2;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op = 2'b01; A = 4'h2; B = 4'h5; C = 4'h1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op = 2'b10; A = 4'b1111; B = 4'b1010; C = 4'b1100;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op = 2'b10; A = 4'hF; B = 4'hA; C = 4'h5;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op = 2'b11; A = 4'b1000; B = 4'b0100; C = 4'b0010;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        op = 2'b11; A = 4'hF; B = 4'h0; C = 4'h5;
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
        input [3:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
