`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [3:0] data_in;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            addr = 0;
            data_in = 0;
            write_enable = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write/Read Address 0");
            reset_dut();


            addr = 2'b00;
            data_in = 4'hA;
            write_enable = 1;
            @(posedge clk);


            write_enable = 0;
            @(posedge clk);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Write/Read Address 3");
            reset_dut();


            addr = 2'b11;
            data_in = 4'h5;
            write_enable = 1;
            @(posedge clk);


            write_enable = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Write Enable Check");
            reset_dut();


            addr = 2'b01;
            data_in = 4'h7;
            write_enable = 1;
            @(posedge clk);


            data_in = 4'hE;
            write_enable = 0;
            @(posedge clk);


            addr = 2'b01;
            @(posedge clk);

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Address Isolation Check");
            reset_dut();


            addr = 2'b00; data_in = 4'h1; write_enable = 1; @(posedge clk);

            addr = 2'b01; data_in = 4'h2; write_enable = 1; @(posedge clk);

            addr = 2'b10; data_in = 4'h4; write_enable = 1; @(posedge clk);

            addr = 2'b11; data_in = 4'h8; write_enable = 1; @(posedge clk);


            write_enable = 0;
            addr = 2'b01;
            @(posedge clk);

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Overwrite Value Check");
            reset_dut();


            addr = 2'b10;
            data_in = 4'hC;
            write_enable = 1;
            @(posedge clk);


            data_in = 4'h3;
            @(posedge clk);


            write_enable = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, write_enable, data_out);
    end

endmodule
