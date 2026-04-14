`timescale 1ns/1ps

module fsm_tb;

    // Testbench signals (combinational circuit)
    reg b;
    reg clk;
    reg [1:0] q;
    wire Q0;
    wire v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm dut (
        .b(b),
        .clk(clk),
        .q(q),
        .Q0(Q0),
        .v(v)
    );
    task testcase001;

    begin
        $display("Test Case 001: State 00, b = 0");
        test_num = 1;


        q = 2'b00; b = 1'b0;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: State 00, b = 1");
        test_num = 2;


        q = 2'b00; b = 1'b1;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: State 01, b = 0");
        test_num = 3;


        q = 2'b01; b = 1'b0;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: State 01, b = 1");
        test_num = 4;


        q = 2'b01; b = 1'b1;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: State 10, b = 0");
        test_num = 5;


        q = 2'b10; b = 1'b0;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: State 10, b = 1");
        test_num = 6;


        q = 2'b10; b = 1'b1;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: State 11, b = 0");
        test_num = 7;


        q = 2'b11; b = 1'b0;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: State 11, b = 1");
        test_num = 8;


        q = 2'b11; b = 1'b1;
        #10; clk = 1; #10; clk = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm Testbench");
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
        input expected_Q0;
        input expected_v;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, v=%b",
                         Q0, v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, v=%b",
                         expected_Q0, expected_v);
                $display("  Got:      Q0=%b, v=%b",
                         Q0, v);
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
