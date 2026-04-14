`timescale 1ns/1ps

module conditional_output_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] C;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conditional_output dut (
        .A(A),
        .B(B),
        .C(C),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=0, Select A", test_num);
            A = 4'hA;
            B = 4'h5;
            C = 2'd0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=0, Select A (All High)", test_num);
            A = 4'hF;
            B = 4'h0;
            C = 2'd0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=1, Select B", test_num);
            A = 4'hA;
            B = 4'h5;
            C = 2'd1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=1, Select B (All High)", test_num);
            A = 4'h0;
            B = 4'hF;
            C = 2'd1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=2, XOR A and B (Alternating bits)", test_num);
            A = 4'b1010;
            B = 4'b0101;
            C = 2'd2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=2, XOR A and B (Identical)", test_num);
            A = 4'hF;
            B = 4'hF;
            C = 2'd2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=2, XOR A and B (Zero/Value)", test_num);
            A = 4'h0;
            B = 4'hC;
            C = 2'd2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C=2, XOR A and B (Specific bits)", test_num);
            A = 4'b0011;
            B = 4'b0101;
            C = 2'd2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conditional_output Testbench");
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
        input [3:0] expected_out;
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
