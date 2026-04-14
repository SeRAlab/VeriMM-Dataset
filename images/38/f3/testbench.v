`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg [3:0] S;
    reg clk;
    reg rst;
    wire [3:0] Q;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .D(D),
        .S(S),
        .clk(clk),
        .rst(rst),
        .Q(Q),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        D = 0;
        S = 0;
        @(posedge clk);
        #1 rst = 0;

        repeat(2) @(posedge clk);
    end
        endtask
    task run_division;

        input [3:0] dividend;
        input [3:0] divisor;
    begin
        D = dividend;
        S = divisor;
        @(posedge clk);

        repeat(10) @(posedge clk);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: 15 / 3", test_num);
        reset_dut();
        run_division(4'd15, 4'd3);
        #1;

        check_outputs(4'd5, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: 7 / 2", test_num);
        reset_dut();
        run_division(4'd7, 4'd2);
        #1;

        check_outputs(4'd3, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: 2 / 5", test_num);
        reset_dut();
        run_division(4'd2, 4'd5);
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: 13 / 1", test_num);
        reset_dut();
        run_division(4'd13, 4'd1);
        #1;

        check_outputs(4'd13, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: 0 / 7", test_num);
        reset_dut();
        run_division(4'd0, 4'd7);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: 15 / 15", test_num);
        reset_dut();
        run_division(4'd15, 4'd15);
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: 15 / 1", test_num);
        reset_dut();
        run_division(4'd15, 4'd1);
        #1;

        check_outputs(4'd15, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: 10 / 4", test_num);
        reset_dut();
        run_division(4'd10, 4'd4);
        #1;

        check_outputs(4'd2, 4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: 13 / 3", test_num);
        reset_dut();
        run_division(4'd13, 4'd3);
        #1;

        check_outputs(4'd4, 4'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: 1 / 1", test_num);
        reset_dut();
        run_division(4'd1, 4'd1);
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("restoring_divider Testbench");
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
        input [3:0] expected_Q;
        input [3:0] expected_R;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,D, S, clk, rst, Q, R);
    end

endmodule
