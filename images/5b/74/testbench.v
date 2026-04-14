`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [1:0] sel;
    wire [7:0] S;

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
        .sel(sel),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Input A (sel = 00)", test_num);
            A = 8'hA1;
            B = 8'hB2;
            C = 8'hC3;
            D = 8'hD4;
            sel = 2'b00;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Input B (sel = 01)", test_num);
            A = 8'hA1;
            B = 8'hB2;
            C = 8'hC3;
            D = 8'hD4;
            sel = 2'b01;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Input C (sel = 10)", test_num);
            A = 8'hA1;
            B = 8'hB2;
            C = 8'hC3;
            D = 8'hD4;
            sel = 2'b10;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Input D (sel = 11)", test_num);
            A = 8'hA1;
            B = 8'hB2;
            C = 8'hC3;
            D = 8'hD4;
            sel = 2'b11;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs same value", test_num);
            A = 8'hFF;
            B = 8'hFF;
            C = 8'hFF;
            D = 8'hFF;
            sel = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary values (00)", test_num);
            A = 8'h00;
            B = 8'hFF;
            C = 8'h55;
            D = 8'hAA;
            sel = 2'b00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary values (FF)", test_num);
            A = 8'h00;
            B = 8'hFF;
            C = 8'h55;
            D = 8'hAA;
            sel = 2'b01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify bit patterns (55)", test_num);
            A = 8'h00;
            B = 8'hFF;
            C = 8'h55;
            D = 8'hAA;
            sel = 2'b10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify bit patterns (AA)", test_num);
            A = 8'h00;
            B = 8'hFF;
            C = 8'h55;
            D = 8'hAA;
            sel = 2'b11;
            #1;

            check_outputs(8'hAA);
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
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
