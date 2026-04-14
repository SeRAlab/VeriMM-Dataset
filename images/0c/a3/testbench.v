`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg write;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            write = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic Write and Read (0xAA)");
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Enable Signal - Prevent Write when Enable=0");
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;


            enable = 0;
            write = 1;
            data_in = 8'hEE;
            @(posedge clk);
            #1;


            enable = 1;
            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Enable Signal - Prevent Read when Enable=0");
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;


            enable = 0;
            write = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Successive Writes (Boundary Values)");
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1;


            data_in = 8'hFF;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Data Persistence over multiple idle cycles");
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 8'h3C;
            @(posedge clk);
            #1;


            enable = 0;
            repeat(3) @(posedge clk);
            #1;


            enable = 1;
            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h3C);
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
        $dumpvars(0,clk, data_in, enable, write, data_out);
    end

endmodule
