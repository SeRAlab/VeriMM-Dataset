`timescale 1ns/1ps

module fsm_example5_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg i;
    reg [2:0] s;
    wire S1;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_example5 dut (
        .clk(clk),
        .i(i),
        .s(s),
        .S1(S1),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: State=000, i=0");
        s = 3'b000; i = 1'b0;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: State=000, i=1");
        s = 3'b000; i = 1'b1;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: State=001, i=0");
        s = 3'b001; i = 1'b0;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: State=001, i=1");
        s = 3'b001; i = 1'b1;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: State=010, i=0");
        s = 3'b010; i = 1'b0;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: State=010, i=1");
        s = 3'b010; i = 1'b1;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: State=011, i=0");
        s = 3'b011; i = 1'b0;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: State=011, i=1");
        s = 3'b011; i = 1'b1;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: State=100, i=0");
        s = 3'b100; i = 1'b0;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: State=100, i=1");
        s = 3'b100; i = 1'b1;
        clk = 0; #5; clk = 1; #5; clk = 0; #5;
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
        $display("fsm_example5 Testbench");
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
        input expected_S1;
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S1 === (expected_S1 ^ S1 ^ expected_S1) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: S1=%b, y=%b",
                         S1, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S1=%b, y=%b",
                         expected_S1, expected_y);
                $display("  Got:      S1=%b, y=%b",
                         S1, y);
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
