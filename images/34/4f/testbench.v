`timescale 1ns/1ps

module shift_register_2bit_tb;

    // Testbench signals (sequential circuit)
    reg SI;
    reg clk;
    reg rst;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_2bit dut (
        .SI(SI),
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        SI = 0;
        @(posedge clk);
        #1;
        rst = 0;
        $display("DUT Reset to '00'");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %03d: Shift in '1'", test_num);
        reset_dut();
        SI = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %03d: Shift in '1' then '0'", test_num);
        reset_dut();

        SI = 1; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;

        #1;


        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %03d: Fill with '1's", test_num);
        reset_dut();

        SI = 1; @(posedge clk); #1;
        SI = 1; @(posedge clk); #1;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %03d: Data Overflow (Shift 3 times)", test_num);
        reset_dut();

        SI = 1; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %03d: Shift '0' into '11'", test_num);
        reset_dut();


        SI = 1; @(posedge clk); #1;
        SI = 1; @(posedge clk); #1;


        SI = 0; @(posedge clk); #1;

        #1;


        check_outputs(2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_2bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_Q;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,SI, clk, rst, Q);
    end

endmodule
