`timescale 1ns/1ps

module lru_cache_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [7:0] data_in;
    reg write;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lru_cache dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
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
            address = 0;
            data_in = 0;
            write = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read");


            @(posedge clk);
            address = 8'h10; data_in = 8'hAA; write = 1;
            @(posedge clk);


            write = 0;
            address = 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Fill Cache (4 lines)");


            @(posedge clk);
            address = 8'h01; data_in = 8'h11; write = 1; @(posedge clk);
            address = 8'h02; data_in = 8'h22; write = 1; @(posedge clk);
            address = 8'h03; data_in = 8'h33; write = 1; @(posedge clk);
            address = 8'h04; data_in = 8'h44; write = 1; @(posedge clk);


            write = 0;
            address = 8'h04;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Basic LRU Eviction (Write 5th replaces 1st)");


            @(posedge clk);
            address = 8'h01; data_in = 8'h11; write = 1; @(posedge clk);
            address = 8'h02; data_in = 8'h22; write = 1; @(posedge clk);
            address = 8'h03; data_in = 8'h33; write = 1; @(posedge clk);
            address = 8'h04; data_in = 8'h44; write = 1; @(posedge clk);


            address = 8'h05; data_in = 8'h55; write = 1; @(posedge clk);


            write = 0;
            address = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: LRU Update via Read Access");


            @(posedge clk);
            address = 8'h01; data_in = 8'h11; write = 1; @(posedge clk);
            address = 8'h02; data_in = 8'h22; write = 1; @(posedge clk);
            address = 8'h03; data_in = 8'h33; write = 1; @(posedge clk);
            address = 8'h04; data_in = 8'h44; write = 1; @(posedge clk);


            write = 0;
            address = 8'h01; @(posedge clk);


            write = 1;
            address = 8'h05; data_in = 8'h55; @(posedge clk);


            write = 0;
            address = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Write Hit (Update data)");


            @(posedge clk);
            address = 8'hA0; data_in = 8'h01; write = 1; @(posedge clk);


            address = 8'hA0; data_in = 8'hFF; write = 1; @(posedge clk);


            write = 0;
            address = 8'hA0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lru_cache Testbench");
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
        $dumpvars(0,address, clk, data_in, write, data_out);
    end

endmodule
