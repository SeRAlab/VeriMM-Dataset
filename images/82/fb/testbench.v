`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [2:0] B;
    reg C;
    reg D;
    reg E;
    reg F;
    reg G;
    reg H;
    wire out;

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
        .E(E),
        .F(F),
        .G(G),
        .H(H),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;

            A = 2'b01; B = 3'b000; C = 1'b1; D = 1'b0;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            A = 2'b10; B = 3'b000; C = 1'b1; D = 1'b0;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            A = 2'b00; B = 3'b001; C = 1'b0; D = 1'b1;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            A = 2'b01; B = 3'b001; C = 1'b0; D = 1'b1;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            A = 2'b00; B = 3'b000; C = 1'b0; D = 1'b0;
            E = 1'b1; F = 1'b1; G = 1'b1; H = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            A = 2'b00; B = 3'b000; C = 1'b0; D = 1'b0;
            E = 1'b1; F = 1'b1; G = 1'b1; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;


            A = 2'b10; B = 3'b001; C = 1'b1; D = 1'b1;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;


            A = 2'b01; B = 3'b011; C = 1'b1; D = 1'b1;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            A = 2'b00; B = 3'b000; C = 1'b0; D = 1'b0;
            E = 1'b0; F = 1'b0; G = 1'b0; H = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;


            A = 2'b10; B = 3'b110; C = 1'b1; D = 1'b1;
            E = 1'b1; F = 1'b1; G = 1'b1; H = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
