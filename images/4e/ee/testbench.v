`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] Data_A;
    reg [8:0] Data_B;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_A(Data_A),
        .Data_B(Data_B),
        .less(less)
    );
    task testcase001;

    begin
        test_num = 1;
        Data_A = 9'd0;
        Data_B = 9'd0;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=0)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Data_A = 9'd0;
        Data_B = 9'd1;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=1)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Data_A = 9'd1;
        Data_B = 9'd0;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=0)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Data_A = 9'h1FF;
        Data_B = 9'h1FF;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=0)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Data_A = 9'd255;
        Data_B = 9'd256;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=1)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Data_A = 9'd256;
        Data_B = 9'd255;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=0)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Data_A = 9'd123;
        Data_B = 9'd456;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=1)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Data_A = 9'd456;
        Data_B = 9'd123;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=0)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Data_A = 9'd0;
        Data_B = 9'd511;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=1)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Data_A = 9'd510;
        Data_B = 9'd511;
        $display("Test %0d: Data_A=%d, Data_B=%d (Expected less=1)", test_num, Data_A, Data_B);
        #1;

        check_outputs(1'b1);
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
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: less=%b",
                         less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: less=%b",
                         expected_less);
                $display("  Got:      less=%b",
                         less);
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
