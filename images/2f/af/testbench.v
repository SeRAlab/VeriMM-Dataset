`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] parallel_in;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            start = 0;
            parallel_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        reg [31:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase001: All Ones (32'hFFFFFFFF)");
            reset_dut();
            data = 32'hFFFFFFFF;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            for (i = 0; i < 31; i = i + 1) begin
                if (serial_out !== data[31-i]) $display("  Error at bit %0d", 31-i);
                if (done !== 0) $display("  Error: done signal high at bit %0d", 31-i);
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(1'b1, data[0]);
        end
        endtask

    task testcase002;

        reg [31:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase002: All Zeros (32'h00000000)");
            reset_dut();
            data = 32'h00000000;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            for (i = 0; i < 31; i = i + 1) begin
                if (serial_out !== data[31-i]) $display("  Error at bit %0d", 31-i);
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1, data[0]);
        end
        endtask

    task testcase003;

        reg [31:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase003: Alternating Bits (32'hAAAAAAAA)");
            reset_dut();
            data = 32'hAAAAAAAA;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            for (i = 0; i < 31; i = i + 1) begin
                if (serial_out !== data[31-i]) $display("  Error at bit %0d", 31-i);
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1, data[0]);
        end
        endtask

    task testcase004;

        reg [31:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase004: Alternating Bits (32'h55555555)");
            reset_dut();
            data = 32'h55555555;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            for (i = 0; i < 31; i = i + 1) begin
                if (serial_out !== data[31-i]) $display("  Error at bit %0d", 31-i);
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1, data[0]);
        end
        endtask

    task testcase005;

        reg [31:0] data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase005: Boundary Bits (32'h80000001)");
            reset_dut();
            data = 32'h80000001;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            for (i = 0; i < 31; i = i + 1) begin
                if (serial_out !== data[31-i]) $display("  Error at bit %0d", 31-i);
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1, data[0]);
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
        $dumpvars(0,clk, parallel_in, rst, start, done, serial_out);
    end

endmodule
