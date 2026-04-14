`timescale 1ns/1ps

module LFSR_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [15:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR_16bit dut (
        .clk(clk),
        .rst(rst),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        reg [15:0] expected_val;
        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Single Cycle Transition", test_num);
            reset_dut();

            expected_val = 16'h0001;
            expected_val = lfsr_model(expected_val);

            @(posedge clk);
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        reg [15:0] expected_val;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: 16-Cycle Shift", test_num);
            reset_dut();

            expected_val = 16'h0001;
            for (i = 0; i < 16; i = i + 1) begin
                expected_val = lfsr_model(expected_val);
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        reg [15:0] expected_val;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Long Sequence (255 cycles)", test_num);
            reset_dut();

            expected_val = 16'h0001;
            for (i = 0; i < 255; i = i + 1) begin
                expected_val = lfsr_model(expected_val);
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        reg [15:0] expected_val;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Non-zero Persistence (1024 cycles)", test_num);
            reset_dut();

            expected_val = 16'h0001;
            for (i = 0; i < 1024; i = i + 1) begin
                expected_val = lfsr_model(expected_val);
                @(posedge clk);
            end
            #1;


            if (lfsr_out == 16'h0000) begin
                $display("FAIL: LFSR stuck at zero!");
                fail_count = fail_count + 1;
            end else begin
                #1;

                check_outputs(expected_val);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR_16bit Testbench");
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
        input [15:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, rst, lfsr_out);
    end

endmodule
