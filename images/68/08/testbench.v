`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] A;
    reg [11:0] B;
    reg [11:0] C;
    reg [11:0] D;
    reg [11:0] E;
    reg [3:0] I;
    wire [11:0] O;

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
        .I(I),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A (I=0000)", test_num);
            I = 4'b0000;
            A = 12'hAAA; B = 12'hBBB; C = 12'hCCC; D = 12'hDDD; E = 12'hEEE;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B (I=0001)", test_num);
            I = 4'b0001;
            A = 12'h111; B = 12'h222; C = 12'h333; D = 12'h444; E = 12'h555;
            #1;

            check_outputs(12'h222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select C (I=0010)", test_num);
            I = 4'b0010;
            A = 12'hFED; B = 12'hCBA; C = 12'h987; D = 12'h654; E = 12'h321;
            #1;

            check_outputs(12'h987);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D (I=0011)", test_num);
            I = 4'b0011;
            A = 12'h000; B = 12'hFFF; C = 12'h555; D = 12'hAAA; E = 12'h123;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select E (I=0100)", test_num);
            I = 4'b0100;
            A = 12'h123; B = 12'h456; C = 12'h789; D = 12'hABC; E = 12'hDEF;
            #1;

            check_outputs(12'hDEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default case (I=0101)", test_num);
            I = 4'b0101;
            A = 12'hAAA; B = 12'hBBB; C = 12'hCCC; D = 12'hDDD; E = 12'hEEE;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default case (I=1111)", test_num);
            I = 4'b1111;
            A = 12'hFFF; B = 12'hFFF; C = 12'hFFF; D = 12'hFFF; E = 12'hFFF;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs check (I=0010)", test_num);
            I = 4'b0010;
            A = 12'h000; B = 12'h000; C = 12'h000; D = 12'h000; E = 12'h000;
            #1;

            check_outputs(12'h000);
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
        input [11:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
