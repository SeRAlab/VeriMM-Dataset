`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] parallel_in;
    reg rst_n;
    reg start;
    wire done;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        start = 0;
        parallel_in = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Serializing 0x0000", test_num);
        reset_dut();

        parallel_in = 16'h0000;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;



        repeat(15) @(posedge clk);


        #1 #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Serializing 0xFFFF", test_num);
        reset_dut();

        parallel_in = 16'hFFFF;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(15) @(posedge clk);


        #1 #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Serializing 0xAAAA", test_num);
        reset_dut();

        parallel_in = 16'hAAAA;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(15) @(posedge clk);


        #1 #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Serializing 0x5555", test_num);
        reset_dut();

        parallel_in = 16'h5555;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(15) @(posedge clk);


        #1 #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Serializing 0x0001", test_num);
        reset_dut();

        parallel_in = 16'h0001;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(15) @(posedge clk);


        #1 #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Serializing 0x8000", test_num);
        reset_dut();

        parallel_in = 16'h8000;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(15) @(posedge clk);


        #1 #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        input expected_done;
        input expected_serial_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, serial_out=%b",
                         done, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, serial_out=%b",
                         expected_done, expected_serial_out);
                $display("  Got:      done=%b, serial_out=%b",
                         done, serial_out);
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
        $dumpvars(0,clk, parallel_in, rst_n, start, done, serial_out);
    end

endmodule
