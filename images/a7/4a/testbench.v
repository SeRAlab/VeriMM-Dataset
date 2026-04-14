`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Num;
    wire [7:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Num(Num),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            Num = 4'h0;
            #10;
            $display("Test Case %0d: Input 4'h0 (Decimal 0)", test_num);
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Num = 4'h1;
            #10;
            $display("Test Case %0d: Input 4'h1 (Decimal 1)", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Num = 4'h2;
            #10;
            $display("Test Case %0d: Input 4'h2 (Decimal 2)", test_num);
            #1;

            check_outputs(8'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Num = 4'h3;
            #10;
            $display("Test Case %0d: Input 4'h3 (Decimal 3)", test_num);
            #1;

            check_outputs(8'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Num = 4'h4;
            #10;
            $display("Test Case %0d: Input 4'h4 (Decimal 4)", test_num);
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Num = 4'h5;
            #10;
            $display("Test Case %0d: Input 4'h5 (Decimal 5)", test_num);
            #1;

            check_outputs(8'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Num = 4'h6;
            #10;
            $display("Test Case %0d: Input 4'h6 (Decimal 6)", test_num);
            #1;

            check_outputs(8'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Num = 4'h7;
            #10;
            $display("Test Case %0d: Input 4'h7 (Decimal 7)", test_num);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            Num = 4'h8;
            #10;
            $display("Test Case %0d: Input 4'h8 (Decimal 8)", test_num);
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            Num = 4'h9;
            #10;
            $display("Test Case %0d: Input 4'h9 (Decimal 9)", test_num);
            #1;

            check_outputs(8'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            Num = 4'hA;
            #10;
            $display("Test Case %0d: Input 4'hA (Hex A)", test_num);
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            Num = 4'hB;
            #10;
            $display("Test Case %0d: Input 4'hB (Hex B)", test_num);
            #1;

            check_outputs(8'h7C);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            Num = 4'hC;
            #10;
            $display("Test Case %0d: Input 4'hC (Hex C)", test_num);
            #1;

            check_outputs(8'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            Num = 4'hD;
            #10;
            $display("Test Case %0d: Input 4'hD (Hex D)", test_num);
            #1;

            check_outputs(8'h5E);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            Num = 4'hE;
            #10;
            $display("Test Case %0d: Input 4'hE (Hex E)", test_num);
            #1;

            check_outputs(8'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            Num = 4'hF;
            #10;
            $display("Test Case %0d: Input 4'hF (Hex F)", test_num);
            #1;

            check_outputs(8'h71);
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [7:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
