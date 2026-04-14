`timescale 1ns/1ps

module parallel_to_serial_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [7:0] parallel_in;
    reg rst;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .clk(clk),
        .en(en),
        .load(load),
        .parallel_in(parallel_in),
        .rst(rst),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 0;
        en = 0;
        load = 0;
        parallel_in = 8'h00;
        @(posedge clk);
        #1 rst = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

        reg [7:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Parallel to Serial - 8'hAA", test_num);
            reset_dut();

            data = 8'hAA;
            parallel_in = data;
            load = 1;
            en = 0;
            @(posedge clk);
            #1;

            load = 0;
            en = 1;

            for (i = 0; i < 8; i = i + 1) begin
                $display("Checking bit %0d...", i);
                #1;

                check_outputs(data[7-i]);
                @(posedge clk);
                #1;
            end
            en = 0;
        end
        endtask

    task testcase002;

        reg [7:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Parallel to Serial - 8'hF0", test_num);
            reset_dut();

            data = 8'hF0;
            parallel_in = data;
            load = 1;
            en = 0;
            @(posedge clk);
            #1;

            load = 0;
            en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                $display("Checking bit %0d...", i);
                #1;

                check_outputs(data[7-i]);
                @(posedge clk);
                #1;
            end
            en = 0;
        end
        endtask

    task testcase003;

        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Gating", test_num);
            reset_dut();

            data = 8'hC0;
            parallel_in = data;
            load = 1;
            en = 0;
            @(posedge clk);
            #1;

            load = 0;
            en = 1;

            #1;


            check_outputs(data[7]);
            @(posedge clk);
            #1;


            en = 0;
            $display("Gating enable (en=0)...");
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(data[6]);


            en = 1;
            $display("Resuming shift...");
            #1;

            check_outputs(data[6]);
            @(posedge clk);
            #1;
            #1;

            check_outputs(data[5]);
            en = 0;
        end
        endtask

    task testcase004;

        reg [7:0] data1, data2;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Load and Shift", test_num);
            reset_dut();

            data1 = 8'h01;
            data2 = 8'h80;


            parallel_in = data1;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            repeat(7) @(posedge clk);
            #1;


            parallel_in = data2;
            load = 1;
            en = 0;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;


            #1;



            check_outputs(data2[7]);
            en = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_to_serial Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, en, load, parallel_in, rst, serial_out);
    end

endmodule
