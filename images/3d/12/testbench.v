`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg rw;
    reg start;
    wire ready;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .rw(rw),
        .start(start),
        .ready(ready),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 7'b0;
            data_in = 8'b0;
            rw = 0;
            start = 0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset and Idle Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Basic Write Transaction (Addr=0x50, Data=0xA5)", test_num);
            reset_dut();

            addr = 7'h50;
            data_in = 8'hA5;
            rw = 0;
            start = 1;

            @(posedge clk);
            start = 0;


            wait(ready == 0);

            wait(ready == 1);


            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Basic Read Transaction (Addr=0x3C)", test_num);
            reset_dut();

            addr = 7'h3C;
            rw = 1;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(ready == 0);
            wait(ready == 1);

            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Consecutive Write Transactions", test_num);
            reset_dut();


            addr = 7'h11;
            data_in = 8'hAA;
            rw = 0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(ready == 0);
            wait(ready == 1);

            repeat (10) @(posedge clk);


            addr = 7'h22;
            data_in = 8'hBB;
            rw = 0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(ready == 0);
            wait(ready == 1);

            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Zero Pattern Transaction", test_num);
            reset_dut();

            addr = 7'h00;
            data_in = 8'h00;
            rw = 0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 0);
            wait(ready == 1);

            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_ready;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, scl=%b, sda=%b",
                         ready, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, scl=%b, sda=%b",
                         expected_ready, expected_scl, expected_sda);
                $display("  Got:      ready=%b, scl=%b, sda=%b",
                         ready, scl, sda);
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
        $dumpvars(0,addr, clk, data_in, rst, rw, start, ready, scl, sda);
    end

endmodule
