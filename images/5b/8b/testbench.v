`timescale 1ns/1ps

module SISO_8_tb;

    // Testbench signals (sequential circuit)
    reg SI;
    reg clk;
    reg rst;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_8 dut (
        .SI(SI),
        .clk(clk),
        .rst(rst),
        .SO(SO)
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
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in All 1s", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                SI = 1;
            end
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single 1 Propagation", test_num);
            reset_dut();
            @(negedge clk) SI = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(negedge clk);
                SI = 0;
            end
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify 8-bit Length (Shift 9 times)", test_num);
            reset_dut();
            @(negedge clk) SI = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                SI = 0;
            end
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 10101010", test_num);
            pattern = 8'b10101010;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                SI = pattern[i];
            end
            @(posedge clk); #1;
            #1;

            check_outputs(pattern[0]);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Mid-operation", test_num);
            reset_dut();

            repeat(4) @(negedge clk) SI = 1;

            #2 rst = 1;
            #1;
            #1;

            check_outputs(1'b0);
            #2 rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SISO_8 Testbench");
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
        input expected_SO;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: SO=%b",
                         SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%b",
                         expected_SO);
                $display("  Got:      SO=%b",
                         SO);
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
        $dumpvars(0,SI, clk, rst, SO);
    end

endmodule
