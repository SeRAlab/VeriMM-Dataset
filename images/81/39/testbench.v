`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg load;
    reg [15:0] parallel_data;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clear(clear),
        .clk(clk),
        .load(load),
        .parallel_data(parallel_data),
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
        reset = 1;
        load = 0;
        clear = 0;
        parallel_data = 16'h0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power-on Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load Load 16'hAAAA", test_num);
        reset_dut();
        load = 1;
        parallel_data = 16'hAAAA;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Synchronous Clear", test_num);
        reset_dut();

        load = 1;
        parallel_data = 16'hFFFF;
        @(posedge clk);
        #1 load = 0;

        clear = 1;
        @(posedge clk);
        #1 clear = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority Check (Clear over Load)", test_num);
        reset_dut();

        clear = 1;
        load = 1;
        parallel_data = 16'h5555;
        @(posedge clk);
        #1 clear = 0; load = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Hold Check", test_num);
        reset_dut();

        load = 1;
        parallel_data = 16'h1234;
        @(posedge clk);
        #1 load = 0;
        parallel_data = 16'h0000;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern Load 16'hF0F0", test_num);
        reset_dut();
        load = 1;
        parallel_data = 16'hF0F0;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'hF0F0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clear, clk, load, parallel_data, reset, q);
    end

endmodule
