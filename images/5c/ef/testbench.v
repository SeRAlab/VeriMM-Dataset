`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg ctrl;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd10; B = 8'd5; ctrl = 1'b0;
            #10;
            $display("Test %0d: Unsigned 10 * 5 (Expect 50)", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'd200; B = 8'd1; ctrl = 1'b0;
            #10;
            $display("Test %0d: Unsigned 200 * 1 (Expect 200)", test_num);
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd255; B = 8'd2; ctrl = 1'b0;
            #10;
            $display("Test %0d: Unsigned 255 * 2 (Expect 510 mod 256 = 254)", test_num);
            #1;

            check_outputs(8'd254);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'sd12; B = 8'sd4; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed 12 * 4 (Expect 48)", test_num);
            #1;

            check_outputs(8'sd48);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'sd10; B = -8'sd5; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed 10 * -5 (Expect -50)", test_num);
            #1;

            check_outputs(-8'sd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = -8'sd8; B = -8'sd4; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed -8 * -4 (Expect 32)", test_num);
            #1;

            check_outputs(8'sd32);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'sd20; B = 8'sd10; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed 20 * 10 (200 > 127, Expect Saturation 127)", test_num);
            #1;

            check_outputs(8'sd127);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = -8'sd20; B = 8'sd10; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed -20 * 10 (-200 < -128, Expect Saturation 127 per spec)", test_num);
            #1;

            check_outputs(8'sd127);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = -8'sd1; B = 8'sd127; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed -1 * 127 (Expect -127)", test_num);
            #1;

            check_outputs(-8'sd127);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'd0; B = -8'sd128; ctrl = 1'b1;
            #10;
            $display("Test %0d: Signed 0 * -128 (Expect 0)", test_num);
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
