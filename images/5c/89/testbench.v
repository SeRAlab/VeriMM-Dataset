`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'd0;
        B = 8'd25;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'd50;
        B = 8'd0;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'd123;
        B = 8'd1;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd123);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'd12;
        B = 8'd9;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd108);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'hFF;
        B = 8'd1;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'd4;
        B = 8'd16;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd64);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 8'd20;
        B = 8'd20;
        $display("Test %0d: A=%d, B=%d (Expect Truncated Result)", test_num, A, B);
        #1;

        check_outputs(8'd144);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 8'b10101010;
        B = 8'd2;
        $display("Test %0d: A=%b, B=%d", test_num, A, B);
        #1;

        check_outputs(8'b01010100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 8'hFF;
        B = 8'hFF;
        $display("Test %0d: A=0xFF, B=0xFF", test_num);

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 8'd13;
        B = 8'd7;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd91);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
