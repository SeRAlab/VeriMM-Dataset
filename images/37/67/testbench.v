`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] phase_in;
    reg rst;
    reg [2:0] shift_amount;
    wire [2:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_in(phase_in),
        .rst(rst),
        .shift_amount(shift_amount),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        phase_in = 3'b000;
        shift_amount = 3'b000;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=3, shift_amount=0", test_num);
        phase_in = 3'd3;
        shift_amount = 3'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=2, shift_amount=3", test_num);
        phase_in = 3'd2;
        shift_amount = 3'd3;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=6, shift_amount=3", test_num);
        phase_in = 3'd6;
        shift_amount = 3'd3;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=7, shift_amount=7", test_num);
        phase_in = 3'd7;
        shift_amount = 3'd7;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=4, shift_amount=4", test_num);
        phase_in = 3'd4;
        shift_amount = 3'd4;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=0, shift_amount=5", test_num);
        phase_in = 3'd0;
        shift_amount = 3'd5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: phase_in=7, shift_amount=1", test_num);
        phase_in = 3'd7;
        shift_amount = 3'd1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [2:0] expected_phase_out;
        begin
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%h",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%h",
                         expected_phase_out);
                $display("  Got:      phase_out=%h",
                         phase_out);
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
        $dumpvars(0,clk, phase_in, rst, shift_amount, phase_out);
    end

endmodule
