`timescale 1ns/1ps

module reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [15:0] data_in;
    reg load;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_16bit dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

    begin
        clear = 1;
        load = 0;
        data_in = 16'h0000;
        #12;
        clear = 0;
        #8;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Parallel Load", test_num);
        @(negedge clk);
        data_in = 16'hABCD;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Hold Data (Load=0)", test_num);

        @(negedge clk);
        data_in = 16'h1234;
        load = 1;
        @(posedge clk);

        @(negedge clk);
        load = 0;
        data_in = 16'hFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Asynchronous Clear Priority", test_num);

        @(negedge clk);
        data_in = 16'h5555;
        load = 1;
        @(posedge clk);
        #2;

        clear = 1;
        #3;
        #1;

        check_outputs(16'h0000);
        clear = 0;
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Load All Ones", test_num);
        @(negedge clk);
        data_in = 16'hFFFF;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Load Toggle Pattern", test_num);
        @(negedge clk);
        data_in = 16'hAAAA;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clear, clk, data_in, load, data_out);
    end

endmodule
