`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [63:0] C;
    reg [63:0] D;
    reg [127:0] E;
    reg [127:0] F;
    wire [127:0] X;
    wire [127:0] Y;

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
        .X(X),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            A = 64'd0;
            B = 64'd0;
            C = 64'd0;
            D = 64'd0;
            E = 128'd0;
            F = 128'd0;



            #1;




            check_outputs(128'd0, 128'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple small values", test_num);
            A = 64'd12;
            B = 64'd10;
            E = 128'd50;
            C = 64'b1011;
            D = 64'b0111;
            F = 128'hA;




            #1;





            check_outputs(128'hAA, 128'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 64-bit product check", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'hFFFF_FFFF_FFFF_FFFF;
            E = 128'd0;
            C = 64'd0;
            D = 64'd0;
            F = 128'd0;



            #1;




            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001, 128'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 128-bit addition overflow for X", test_num);
            A = 64'h0000_0000_0000_0002;
            B = 64'h4000_0000_0000_0000;
            E = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            C = 64'h0;
            D = 64'h0;
            F = 128'h0;


            #1;



            check_outputs(128'h00000000000000007FFFFFFFFFFFFFFF, 128'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum population count for Y", test_num);
            A = 64'd0;
            B = 64'd0;
            E = 128'd0;
            C = 64'hFFFF_FFFF_FFFF_FFFF;
            D = 64'hFFFF_FFFF_FFFF_FFFF;
            F = 128'h100;



            #1;




            check_outputs(128'd0, 128'h140);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits for Y", test_num);
            A = 64'h5;
            B = 64'h5;
            E = 128'h0;
            C = 64'hAAAA_AAAA_AAAA_AAAA;
            D = 64'h5555_5555_5555_5555;
            F = 128'hFFFF;




            #1;





            check_outputs(128'h19, 128'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large E and F values", test_num);
            A = 64'h1;
            B = 64'h1;
            E = 128'h8000_0000_0000_0000_0000_0000_0000_0000;
            C = 64'hF0F0_F0F0_F0F0_F0F0;
            D = 64'hFFFF_FFFF_FFFF_FFFF;
            F = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFC;




            #1;





            check_outputs(128'h80000000000000000000000000000001, 128'h0000000000000000000000000000001C);
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
        input [127:0] expected_X;
        input [127:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: X=%h, Y=%h",
                         X, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h, Y=%h",
                         expected_X, expected_Y);
                $display("  Got:      X=%h, Y=%h",
                         X, Y);
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
