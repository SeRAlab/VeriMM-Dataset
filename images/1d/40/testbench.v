`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] parallel_in;
    reg reset;
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
        .reset(reset),
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
        reset = 1;
        parallel_in = 0;
        @(posedge clk);
        #2 reset = 0;

    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: All Zeros");
        test_num = 1;
        parallel_in = 32'h00000000;
        reset_dut();

        repeat(31) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: All Ones");
        test_num = 2;
        parallel_in = 32'hFFFFFFFF;
        reset_dut();
        repeat(31) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: MSB is 1 (32'h80000000)");
        test_num = 3;
        parallel_in = 32'h80000000;
        reset_dut();
        repeat(31) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: MSB is 0 (32'h7FFFFFFF)");
        test_num = 4;
        parallel_in = 32'h7FFFFFFF;
        reset_dut();
        repeat(31) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Pattern 0xAAAAAAAA");
        test_num = 5;
        parallel_in = 32'hAAAAAAAA;
        reset_dut();
        repeat(31) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Pattern 0x55555555");
        test_num = 6;
        parallel_in = 32'h55555555;
        reset_dut();
        repeat(31) @(posedge clk);
        #2;
        #1;

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
        $dumpvars(0,clk, parallel_in, reset, done, serial_out);
    end

endmodule
