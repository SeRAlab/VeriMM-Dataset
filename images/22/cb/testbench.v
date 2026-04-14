`timescale 1ns/1ps

module PISO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] parallel_in;
    reg rst;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO dut (
        .clk(clk),
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
            rst = 1;
            load = 0;
            parallel_in = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Alternating bits 10101");
            reset_dut();
            test_num = 1;


            parallel_in = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            #1;



            check_outputs(1'b1);
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All ones 11111");
            reset_dut();
            test_num = 2;

            parallel_in = 5'b11111;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat(5) begin
                #1;

                check_outputs(1'b1);
                @(posedge clk); #1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: All zeros 00000");
            reset_dut();
            test_num = 3;

            parallel_in = 5'b00000;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat(5) begin
                #1;

                check_outputs(1'b0);
                @(posedge clk); #1;
            end
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Single bit LSB 00001");
            reset_dut();
            test_num = 4;

            parallel_in = 5'b00001;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            repeat(4) begin
                #1;

                check_outputs(1'b0);
                @(posedge clk); #1;
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset during shift operation");
            reset_dut();
            test_num = 5;

            parallel_in = 5'b11111;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            @(posedge clk); #1;
            @(posedge clk); #1;


            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO Testbench");
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
        $dumpvars(0,clk, load, parallel_in, rst, serial_out);
    end

endmodule
