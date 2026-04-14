`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg clk;
    reg data_in;
    reg read;
    reg write;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .read(read),
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
            address = 3'b0;
            data_in = 1'b0;
            read = 1'b0;
            write = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Writing 1 to Address 0...");
            reset_dut();

            address = 3'd0;
            data_in = 1'b1;
            write = 1'b1;
            read = 1'b0;
            @(posedge clk);
            #1;

            write = 1'b0;
            read = 1'b1;
            address = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Writing 0 to Address 7...");
            reset_dut();

            address = 3'd7;
            data_in = 1'b0;
            write = 1'b1;
            read = 1'b0;
            @(posedge clk);
            #1;

            write = 1'b0;
            read = 1'b1;
            address = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting Address 4 (1 then 0)...");
            reset_dut();

            address = 3'd4;
            data_in = 1'b1;
            write = 1'b1;
            @(posedge clk);
            #1;

            data_in = 1'b0;
            write = 1'b1;
            @(posedge clk);
            #1;

            write = 1'b0;
            read = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify writing to Addr 1 doesn't affect Addr 2...");
            reset_dut();

            address = 3'd1;
            data_in = 1'b1;
            write = 1'b1;
            @(posedge clk);
            #1;

            address = 3'd2;
            data_in = 1'b0;
            write = 1'b1;
            @(posedge clk);
            #1;

            write = 1'b0;
            read = 1'b1;
            address = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying data persists when write is disabled...");
            reset_dut();

            address = 3'd5;
            data_in = 1'b1;
            write = 1'b1;
            @(posedge clk);
            #1;

            write = 1'b0;
            data_in = 1'b0;
            repeat(3) @(posedge clk);
            #1;

            read = 1'b1;
            address = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,address, clk, data_in, read, write, data_out);
    end

endmodule
