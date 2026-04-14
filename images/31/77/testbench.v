`timescale 1ns/1ps

module SRAM_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase001: Verifying memory is zeroed after reset...");
            reset_dut();
            addr = 3'd4;
            we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase002: Simple Write and Read back...");
            reset_dut();

            addr = 3'd2;
            data_in = 8'hA5;
            we = 1;
            @(posedge clk);

            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase003: Writing to boundary address 7...");
            reset_dut();
            addr = 3'd7;
            data_in = 8'hFF;
            we = 1;
            @(posedge clk);
            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase004: Verifying data persistence at address 0...");
            reset_dut();

            addr = 3'd0; data_in = 8'h12; we = 1;
            @(posedge clk);

            #1 addr = 3'd1; data_in = 8'h34; we = 1;
            @(posedge clk);

            #1 we = 0; addr = 3'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase005: Verifying Write Enable (WE) logic...");
            reset_dut();
            addr = 3'd3;
            data_in = 8'h55;
            we = 0;
            @(posedge clk);

            addr = 3'd3;
            we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase006: Verifying overwriting an existing value...");
            reset_dut();

            addr = 3'd5; data_in = 8'hCC; we = 1;
            @(posedge clk);

            #1 data_in = 8'h33;
            @(posedge clk);

            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, reset, we, data_out);
    end

endmodule
