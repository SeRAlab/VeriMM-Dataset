`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd5;
            B = 4'd3;
            C = 1'b0;
            $display("Testcase %0d: Binary Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd15;
            B = 4'd1;
            C = 1'b0;
            $display("Testcase %0d: Binary Addition Wrap (15 + 1)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd10;
            B = 4'd10;
            C = 1'b0;
            $display("Testcase %0d: Binary Addition Overflow (10 + 10)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd0;
            B = 4'd0;
            C = 1'b0;
            $display("Testcase %0d: Binary Addition Zeros (0 + 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b0010;
            B = 4'b0011;
            C = 1'b1;
            $display("Testcase %0d: Two's Complement (+2 + +3)", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b1111;
            B = 4'b0001;
            C = 1'b1;
            $display("Testcase %0d: Two's Complement (-1 + +1)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b0111;
            B = 4'b0001;
            C = 1'b1;
            $display("Testcase %0d: Two's Complement Overflow (+7 + +1)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b1000;
            B = 4'b1000;
            C = 1'b1;
            $display("Testcase %0d: Two's Complement (-8 + -8)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b1110;
            B = 4'b1110;
            C = 1'b1;
            $display("Testcase %0d: Two's Complement (-2 + -2)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'd12;
            B = 4'd4;
            C = 1'b1;
            $display("Testcase %0d: Mixed Mode Check (12 + 4)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
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
