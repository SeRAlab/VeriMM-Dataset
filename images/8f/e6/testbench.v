`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CI;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CI(CI),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h00; CI = 1'b0;
            $display("Test Case %0d: Zero addition (0+0+0)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'h01; B = 8'h02; CI = 1'b0;
            $display("Test Case %0d: Simple addition without carry (1+2+0)", test_num);
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'h0A; B = 8'h14; CI = 1'b1;
            $display("Test Case %0d: Addition with carry-in (10+20+1)", test_num);
            #1;

            check_outputs(8'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h00; CI = 1'b0;
            $display("Test Case %0d: Maximum A value (255+0+0)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h01; CI = 1'b0;
            $display("Test Case %0d: Overflow check (255+1+0)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h00; CI = 1'b1;
            $display("Test Case %0d: Overflow check via Carry-In (255+0+1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'h7F; B = 8'h80; CI = 1'b0;
            $display("Test Case %0d: Half-range addition (127+128+0)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'h80; B = 8'h80; CI = 1'b0;
            $display("Test Case %0d: Power of 2 overflow (128+128+0)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'h55; CI = 1'b0;
            $display("Test Case %0d: Alternating bit pattern (170+85+0)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'h55; CI = 1'b1;
            $display("Test Case %0d: Alternating bit pattern with CI (170+85+1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'hFF; CI = 1'b1;
            $display("Test Case %0d: All inputs high (255+255+1)", test_num);
            #1;

            check_outputs(8'hFF);
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
        testcase011();
        
        
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
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
