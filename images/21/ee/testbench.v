`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] serial_in;
    wire [31:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            serial_in = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic sequence 0x12345678", test_num);
            reset_dut();
            @(negedge clk) serial_in = 8'h12;
            @(negedge clk) serial_in = 8'h34;
            @(negedge clk) serial_in = 8'h56;
            @(negedge clk) serial_in = 8'h78;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Alternating pattern 0x55AAAA55", test_num);
            reset_dut();
            @(negedge clk) serial_in = 8'h55;
            @(negedge clk) serial_in = 8'hAA;
            @(negedge clk) serial_in = 8'hAA;
            @(negedge clk) serial_in = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AAAA55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All Zeros", test_num);
            reset_dut();
            @(negedge clk) serial_in = 8'h00;
            @(negedge clk) serial_in = 8'h00;
            @(negedge clk) serial_in = 8'h00;
            @(negedge clk) serial_in = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All Ones", test_num);
            reset_dut();
            @(negedge clk) serial_in = 8'hFF;
            @(negedge clk) serial_in = 8'hFF;
            @(negedge clk) serial_in = 8'hFF;
            @(negedge clk) serial_in = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: DEADBEEF", test_num);
            reset_dut();
            @(negedge clk) serial_in = 8'hDE;
            @(negedge clk) serial_in = 8'hAD;
            @(negedge clk) serial_in = 8'hBE;
            @(negedge clk) serial_in = 8'hEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_parallel_out;
        input expected_valid;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, valid=%b",
                         parallel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, valid=%b",
                         expected_parallel_out, expected_valid);
                $display("  Got:      parallel_out=%h, valid=%b",
                         parallel_out, valid);
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
        $dumpvars(0,clk, rst, serial_in, parallel_out, valid);
    end

endmodule
