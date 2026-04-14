`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [7:0] parallel_in;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        load = 0;
        serial_in = 0;
        parallel_in = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Synchronous Reset Check", test_num);
        reset_dut();


        reset = 1;
        load = 1;
        parallel_in = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Parallel Load Check", test_num);
        reset_dut();

        load = 1;
        parallel_in = 8'hA5;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] test_pattern;
    begin
        test_num = 3;
        $display("\nTestcase %0d: Serial Shift Left Check (Full 8 bits)", test_num);
        reset_dut();

        enable = 1;
        load = 0;
        test_pattern = 8'hD2;


        for (i = 0; i < 8; i = i + 1) begin
            serial_in = test_pattern[7-i];
            @(posedge clk);
            #1;
        end

        enable = 0;


        #1;



        check_outputs(8'hD2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Enable Signal (Disable) Check", test_num);
        reset_dut();


        load = 1;
        parallel_in = 8'h55;
        @(posedge clk);
        #1;


        load = 0;
        enable = 0;
        serial_in = 1;
        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Load Priority Over Enable Check", test_num);
        reset_dut();


        load = 1;
        enable = 1;
        parallel_in = 8'h3C;
        serial_in = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'h3C);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Mixed Load and Shift Check", test_num);
        reset_dut();


        load = 1;
        parallel_in = 8'h01;
        @(posedge clk);
        #1;


        load = 0;
        enable = 1;
        serial_in = 0;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h04);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, enable, load, parallel_in, reset, serial_in, parallel_out);
    end

endmodule
