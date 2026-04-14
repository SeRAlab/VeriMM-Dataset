`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg SI;
    reg clk;
    reg load;
    reg rst;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .D(D),
        .SI(SI),
        .clk(clk),
        .load(load),
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
        load = 0;
        D = 8'h00;
        SI = 0;
        #12;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Asynchronous Reset");
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Parallel Load");
        test_num = 2;
        reset_dut();
        D = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Serial Shift-In (Pattern 10110010)");
        test_num = 3;
        reset_dut();
        load = 0;

        SI = 1; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;
        SI = 1; @(posedge clk); #1;
        SI = 1; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;
        SI = 1; @(posedge clk); #1;
        SI = 0; @(posedge clk); #1;
        #1;

        check_outputs(8'hB2);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Load Priority Check");
        test_num = 4;
        reset_dut();
        D = 8'hFF;
        SI = 0;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Shift After Load");
        test_num = 5;
        reset_dut();

        D = 8'h01;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        SI = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_Q;
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
        $dumpvars(0,D, SI, clk, load, rst, Q);
    end

endmodule
