`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
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
            we = 1;
            data_in = 8'h00;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            $display("DUT Reset: Stored data initialized to 00h");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Write and Read (AAh)");
            reset_dut();


            we = 1;
            data_in = 8'hAA;
            @(posedge clk);


            we = 0;
            @(posedge clk);

            test_num = test_num + 1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Data Persistence (WE=0)");
            reset_dut();


            we = 1;
            data_in = 8'h55;
            @(posedge clk);


            we = 0;
            data_in = 8'hFF;
            @(posedge clk);

            test_num = test_num + 1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Overwriting Data");
            reset_dut();


            we = 1;
            data_in = 8'h12;
            @(posedge clk);


            we = 1;
            data_in = 8'h34;
            @(posedge clk);


            we = 0;
            @(posedge clk);

            test_num = test_num + 1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Boundary Value Test (FFh)");
            reset_dut();


            we = 1;
            data_in = 8'hFF;
            @(posedge clk);


            we = 0;
            @(posedge clk);

            test_num = test_num + 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multi-cycle Read Persistence");
            reset_dut();


            we = 1;
            data_in = 8'hA5;
            @(posedge clk);


            we = 0;
            data_in = 8'h00;
            repeat(3) @(posedge clk);

            test_num = test_num + 1;
            #1;

            check_outputs(8'hA5);
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
        $dumpvars(0,clk, data_in, we, data_out);
    end

endmodule
