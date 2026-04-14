`timescale 1ns/1ps

module shift_register_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    reg serial_in;
    wire [11:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_12bit dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .serial_in(serial_in),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        en = 0;
        serial_in = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in 12 ones", test_num);
        reset_dut();
        en = 1;
        repeat(12) begin
            serial_in = 1;
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in alternating 1010 pattern", test_num);
        reset_dut();
        en = 1;
        repeat(6) begin
            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);
        end
        #1;
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify enable (en) signal inhibition", test_num);
        reset_dut();
        en = 1;
        serial_in = 1;
        repeat(4) @(posedge clk);
        en = 0;
        serial_in = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h00F);
    end
        endtask

    task testcase004;

    reg [11:0] pattern;
    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in hex pattern 0xA5C", test_num);
        reset_dut();
        pattern = 12'hA5C;
        en = 1;
        for(i=11; i>=0; i=i-1) begin
            serial_in = pattern[i];
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(12'hA5C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify reset priority during operation", test_num);
        reset_dut();
        en = 1;
        serial_in = 1;
        repeat(12) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_12bit Testbench");
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
        input [11:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, en, reset, serial_in, reg_out);
    end

endmodule
