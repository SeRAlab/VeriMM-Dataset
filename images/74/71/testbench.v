`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D;
    reg [3:0] S;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;
        D = 16'hABCD;
        S = 4'b0000;
        #5;
        $display("Test %0d: S=0 (No shift), D=%h", test_num, D);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        D = 16'h0001;
        S = 4'b0001;
        #5;
        $display("Test %0d: S=1 (Left 1), D=%h", test_num, D);
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        D = 16'h0001;
        S = 4'b0111;
        #5;
        $display("Test %0d: S=7 (Left 7), D=%h", test_num, D);
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        D = 16'h8000;
        S = 4'b1111;
        #5;
        $display("Test %0d: S=-1 (Right 1), D=%h", test_num, D);
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        D = 16'hF000;
        S = 4'b1100;
        #5;
        $display("Test %0d: S=-4 (Right 4), D=%h", test_num, D);
        #1;

        check_outputs(16'h0F00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        D = 16'hFFFF;
        S = 4'b1000;
        #5;
        $display("Test %0d: S=-8 (Right 8), D=%h", test_num, D);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        D = 16'hFFFF;
        S = 4'b0100;
        #5;
        $display("Test %0d: S=4 (Left 4), D=%h", test_num, D);
        #1;

        check_outputs(16'hFFF0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        D = 16'h5555;
        S = 4'b0010;
        #5;
        $display("Test %0d: S=2 (Left 2), D=%h", test_num, D);
        #1;

        check_outputs(16'h5554);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        D = 16'h8001;
        S = 4'b1110;
        #5;
        $display("Test %0d: S=-2 (Right 2), D=%h", test_num, D);
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        D = 16'h1234;
        S = 4'b1001;
        #5;
        $display("Test %0d: S=-7 (Right 7), D=%h", test_num, D);
        #1;

        check_outputs(16'h0024);
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
        input [15:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
