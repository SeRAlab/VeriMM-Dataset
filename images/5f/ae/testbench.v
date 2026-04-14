`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] B;
    wire COUT;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No shift (B=00) - Basic Pattern", test_num);
            A = 4'b1011;
            B = 2'b00;
            #10;
            #1;

            check_outputs(1'b0, 4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift by 1 (B=01) - COUT=1 case", test_num);
            A = 4'b1011;
            B = 2'b01;
            #10;

            #1;


            check_outputs(1'b1, 4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift by 1 (B=01) - COUT=0 case", test_num);
            A = 4'b0111;
            B = 2'b01;
            #10;

            #1;


            check_outputs(1'b0, 4'b1110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift by 1 (B=10) - COUT=1 case", test_num);
            A = 4'b1101;
            B = 2'b10;
            #10;

            #1;


            check_outputs(1'b1, 4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift by 1 (B=10) - COUT=0 case", test_num);
            A = 4'b1010;
            B = 2'b10;
            #10;

            #1;


            check_outputs(1'b0, 4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift by 2 (B=11) - COUT=1 case", test_num);
            A = 4'b1110;
            B = 2'b11;
            #10;



            #1;




            check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift by 2 (B=11) - COUT=0 case", test_num);
            A = 4'b1101;
            B = 2'b11;
            #10;

            #1;


            check_outputs(1'b0, 4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones pattern (A=1111)", test_num);
            A = 4'b1111;

            B = 2'b00; #5; #1;
 check_outputs(1'b0, 4'b1111);
            B = 2'b01; #5; #1;
 check_outputs(1'b1, 4'b1110);
            B = 2'b10; #5; #1;
 check_outputs(1'b1, 4'b0111);
            B = 2'b11; #5; #1;
 check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros pattern (A=0000)", test_num);
            A = 4'b0000;

            B = 2'b00; #5; #1;
 check_outputs(1'b0, 4'b0000);
            B = 2'b01; #5; #1;
 check_outputs(1'b0, 4'b0000);
            B = 2'b10; #5; #1;
 check_outputs(1'b0, 4'b0000);
            B = 2'b11; #5; #1;
 check_outputs(1'b0, 4'b0000);
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
        input expected_COUT;
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, Q=%h",
                         COUT, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, Q=%h",
                         expected_COUT, expected_Q);
                $display("  Got:      COUT=%b, Q=%h",
                         COUT, Q);
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
