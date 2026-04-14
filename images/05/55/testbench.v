`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            we = 1;
            addr = 3'd0;
            data_in = 8'hA5;
            @(posedge clk);


            wait(ready == 1);


            we = 0;
            addr = 3'd0;
            @(posedge clk);


            wait(ready == 1);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read at Address 7");
            reset_dut();


            we = 1;
            addr = 3'd7;
            data_in = 8'h5A;
            @(posedge clk);
            wait(ready == 1);


            we = 0;
            addr = 3'd7;
            @(posedge clk);
            wait(ready == 1);

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwrite Address 4");
            reset_dut();


            we = 1; addr = 3'd4; data_in = 8'h11;
            @(posedge clk);
            wait(ready == 1);


            we = 1; addr = 3'd4; data_in = 8'h99;
            @(posedge clk);
            wait(ready == 1);


            we = 0; addr = 3'd4;
            @(posedge clk);
            wait(ready == 1);

            #1;


            check_outputs(8'h99, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify Data Isolation");
            reset_dut();


            we = 1; addr = 3'd1; data_in = 8'hEE;
            @(posedge clk);
            wait(ready == 1);


            we = 1; addr = 3'd2; data_in = 8'hCC;
            @(posedge clk);
            wait(ready == 1);


            we = 0; addr = 3'd1;
            @(posedge clk);
            wait(ready == 1);

            #1;


            check_outputs(8'hEE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [7:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,addr, clk, data_in, we, data_out, ready);
    end

endmodule
