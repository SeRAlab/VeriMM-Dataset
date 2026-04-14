`timescale 1ns/1ps

module async_reset_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    async_reset_register dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        d = 8'h00;
        #12;
        reset = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Reset Verification", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Normal Data Loading (0xAA)", test_num);
        reset_dut();
        d = 8'hAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Data Loading (0x55 -> 0xF0)", test_num);
        reset_dut();
        d = 8'h55;
        @(posedge clk);
        #2;
        d = 8'hF0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous Reset Trigger", test_num);
        reset_dut();
        d = 8'hCC;
        @(posedge clk);
        #2;


        #3;
        reset = 0;
        #1;
        #1;

        check_outputs(8'h00);
        reset = 1;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Stability Check (No Clock Edge)", test_num);
        reset_dut();
        d = 8'h77;
        @(posedge clk);
        #2;
        d = 8'h88;
        #5;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max and Min Values", test_num);
        reset_dut();
        d = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
        d = 8'h00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("async_reset_register Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, reset, q);
    end

endmodule
