`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire [7:0] crc_out;
    wire crc_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .crc_out(crc_out),
        .crc_ready(crc_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            data_valid = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Zero Input (0x00)", test_num);

            data_in = 8'h00;
            data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;

            while (!crc_ready) @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Unit Input (0x01)", test_num);

            data_in = 8'h01;
            data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;

            while (!crc_ready) @(posedge clk);
            #1 #1;
 check_outputs(8'h07, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Alternating Bits (0xAA)", test_num);

            data_in = 8'hAA;
            data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;

            while (!crc_ready) @(posedge clk);
            #1 #1;
 check_outputs(8'hA2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: All Ones (0xFF)", test_num);

            data_in = 8'hFF;
            data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;

            while (!crc_ready) @(posedge clk);
            #1 #1;
 check_outputs(8'hAC, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Pipelined Operation (0x01, then 0x02)", test_num);


            data_in = 8'h01;
            data_valid = 1;
            @(posedge clk);


            #1 data_in = 8'h02;
            data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;


            while (!crc_ready) @(posedge clk);
            #1 #1;
 check_outputs(8'h07, 1'b1);


            @(posedge clk);
            while (!crc_ready) @(posedge clk);
            #1 #1;
 check_outputs(8'h0E, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [7:0] expected_crc_out;
        input expected_crc_ready;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_crc_ready === (expected_crc_ready ^ crc_ready ^ expected_crc_ready)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, crc_ready=%b",
                         crc_out, crc_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, crc_ready=%b",
                         expected_crc_out, expected_crc_ready);
                $display("  Got:      crc_out=%h, crc_ready=%b",
                         crc_out, crc_ready);
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
        $dumpvars(0,clk, data_in, data_valid, reset, crc_out, crc_ready);
    end

endmodule
