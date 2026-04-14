`timescale 1ns/1ps

module kogge_stone_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire COUT;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kogge_stone_adder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero addition", test_num);
        A = 5'h00;
        B = 5'h00;
        #1;

        check_outputs(1'b0, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Simple addition (no carry)", test_num);
        A = 5'h05;
        B = 5'h0A;
        #1;

        check_outputs(1'b0, 5'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Carry propagation (1+1)", test_num);
        A = 5'h01;
        B = 5'h01;
        #1;

        check_outputs(1'b0, 5'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multi-bit propagation", test_num);
        A = 5'h0F;
        B = 5'h01;
        #1;

        check_outputs(1'b0, 5'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max sum without carry out", test_num);
        A = 5'h15;
        B = 5'h0A;
        #1;

        check_outputs(1'b0, 5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Carry out generation", test_num);
        A = 5'h10;
        B = 5'h10;
        #1;

        check_outputs(1'b1, 5'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum inputs (31+31)", test_num);
        A = 5'h1F;
        B = 5'h1F;
        #1;

        check_outputs(1'b1, 5'h1E);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating bit patterns", test_num);
        A = 5'b10101;
        B = 5'b01010;
        #1;

        check_outputs(1'b0, 5'b11111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sparse carry chain", test_num);
        A = 5'b11011;
        B = 5'b00101;

        #1;


        check_outputs(1'b1, 5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kogge_stone_adder Testbench");
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
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
