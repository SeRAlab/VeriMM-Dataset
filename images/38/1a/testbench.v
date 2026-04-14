`timescale 1ns/1ps

module Brent_Kung_Adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Brent_Kung_Adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: A=0, B=0", test_num);
        A = 4'd0;
        B = 4'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: A=5, B=2", test_num);
        A = 4'd5;
        B = 4'd2;
        #1;

        check_outputs(5'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: A=3, B=1", test_num);
        A = 4'b0011;
        B = 4'b0001;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: A=10, B=5", test_num);
        A = 4'd10;
        B = 4'd5;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: A=8, B=8", test_num);
        A = 4'd8;
        B = 4'd8;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: A=15, B=1", test_num);
        A = 4'd15;
        B = 4'd1;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: A=15, B=15", test_num);
        A = 4'd15;
        B = 4'd15;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: A=10, B=10", test_num);
        A = 4'b1010;
        B = 4'b1010;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: A=7, B=9", test_num);
        A = 4'd7;
        B = 4'd9;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: A=12, B=6", test_num);
        A = 4'd12;
        B = 4'd6;
        #1;

        check_outputs(5'd18);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Brent_Kung_Adder Testbench");
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
        input [4:0] expected_SUM;
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
