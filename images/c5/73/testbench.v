`timescale 1ns/1ps

module alu_16_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;
    reg [1:0] op;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_16 dut (
        .A(A),
        .B(B),
        .C(C),
        .op(op),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 16'h1234;
            B = 16'h5678;
            C = 16'h0000;
            op = 2'b00;
            $display("Test Case %0d: A + B (Simple Addition)", test_num);
            #1;

            check_outputs(16'h1234 + 16'h5678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 16'hFFFF;
            B = 16'h0001;
            C = 16'hAAAA;
            op = 2'b00;
            $display("Test Case %0d: A + B (Addition Overflow)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 16'h0010;
            B = 16'h0005;
            C = 16'h0000;
            op = 2'b01;
            $display("Test Case %0d: A - B (Simple Subtraction)", test_num);
            #1;

            check_outputs(16'h000B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 16'h0000;
            B = 16'h0001;
            C = 16'h1234;
            op = 2'b01;
            $display("Test Case %0d: A - B (Subtraction Underflow)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 16'hF0F0;
            B = 16'hAAAA;
            C = 16'h0000;
            op = 2'b10;
            $display("Test Case %0d: A & B (Bitwise AND)", test_num);
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 16'hFFFF;
            B = 16'h1234;
            C = 16'hFFFF;
            op = 2'b10;
            $display("Test Case %0d: A & B (Bitwise AND with All Ones)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 16'hF0F0;
            B = 16'h0F0F;
            C = 16'h0000;
            op = 2'b11;
            $display("Test Case %0d: A | B (Bitwise OR)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 16'h1234;
            B = 16'h0000;
            C = 16'h5678;
            op = 2'b11;
            $display("Test Case %0d: A | B (Bitwise OR with Zero)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 16'h5555;
            B = 16'hAAAA;
            C = 16'hFFFF;
            op = 2'b11;
            $display("Test Case %0d: Verify Input C is ignored", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 16'h0000;
            B = 16'h0000;
            C = 16'h0000;
            op = 2'b01;
            $display("Test Case %0d: Zero result subtraction", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_16 Testbench");
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
        input [15:0] expected_Z;
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
