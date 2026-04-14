`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CI;
    wire COUT_N;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .A(A),
        .B(B),
        .CI(CI),
        .COUT_N(COUT_N),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=0, CI=0", test_num);
            A = 4'h0;
            B = 4'h0;
            CI = 1'b0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=0, CI=1", test_num);
            A = 4'h0;
            B = 4'h0;
            CI = 1'b1;
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=5, B=3, CI=0", test_num);
            A = 4'h5;
            B = 4'h3;
            CI = 1'b0;
            #1;

            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=7, B=7, CI=1", test_num);
            A = 4'h7;
            B = 4'h7;
            CI = 1'b1;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=8, B=8, CI=0 (Carry Check)", test_num);
            A = 4'h8;
            B = 4'h8;
            CI = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=15, CI=1 (Full Max)", test_num);
            A = 4'hF;
            B = 4'hF;
            CI = 1'b1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=0, CI=1", test_num);
            A = 4'hF;
            B = 4'h0;
            CI = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=10, B=5, CI=0", test_num);
            A = 4'hA;
            B = 4'h5;
            CI = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=12, B=12, CI=0", test_num);
            A = 4'hC;
            B = 4'hC;
            CI = 1'b0;
            #1;

            check_outputs(1'b1, 4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1, B=0, CI=0", test_num);
            A = 4'h1;
            B = 4'h0;
            CI = 1'b0;
            #1;

            check_outputs(1'b0, 4'h1);
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
        input expected_COUT_N;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT_N === (expected_COUT_N ^ COUT_N ^ expected_COUT_N) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT_N=%b, SUM=%h",
                         COUT_N, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT_N=%b, SUM=%h",
                         expected_COUT_N, expected_SUM);
                $display("  Got:      COUT_N=%b, SUM=%h",
                         COUT_N, SUM);
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
