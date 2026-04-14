`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .clk(clk),
        .data_in(data_in),
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
            @(negedge clk);
            we = 0;
            data_in = 16'h0000;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Write/Read");
            reset_dut();


            @(negedge clk);
            we = 1;
            data_in = 16'hA5A5;
            @(negedge clk);


            we = 0;
            data_in = 16'h0000;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Write Enable Inhibition");
            reset_dut();


            @(negedge clk);
            we = 1;
            data_in = 16'h1234;
            @(negedge clk);


            we = 0;
            data_in = 16'hFFFF;
            @(negedge clk);


            #1;



            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Write All Ones");
            reset_dut();

            @(negedge clk);
            we = 1;
            data_in = 16'hFFFF;
            @(negedge clk);

            we = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Write All Zeros (Clear)");
            reset_dut();


            @(negedge clk);
            we = 1;
            data_in = 16'hFFFF;
            @(negedge clk);


            data_in = 16'h0000;
            @(negedge clk);

            we = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Consecutive Writes");
            reset_dut();

            @(negedge clk);
            we = 1;
            data_in = 16'h1111;
            @(negedge clk);
            data_in = 16'h2222;
            @(negedge clk);
            data_in = 16'h3333;
            @(negedge clk);
            data_in = 16'h4444;
            @(negedge clk);

            we = 0;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, we, data_out);
    end

endmodule
