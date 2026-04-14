`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg enable;
    reg read_en;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            enable = 0;
            read_en = 0;
            write_en = 0;
            @(negedge clk);


        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Basic Write and Read at Address 0");
            @(negedge clk);
            enable = 1;
            write_en = 1;
            addr = 4'h0;
            data_in = 16'hABCD;
            @(negedge clk);
            write_en = 0;
            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Write and Read at Address 15");
            @(negedge clk);
            enable = 1;
            write_en = 1;
            addr = 4'hF;
            data_in = 16'h55AA;
            @(negedge clk);
            write_en = 0;
            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Verify Enable signal gates Write");

            @(negedge clk);
            enable = 0;
            write_en = 1;
            addr = 4'h5;
            data_in = 16'h1234;
            @(negedge clk);

            write_en = 0;
            read_en = 1;
            enable = 1;
            @(posedge clk);
            #1;

            if (data_out === 16'h1234) begin
                $display("FAIL: Data written while enable was low!");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Write inhibited by enable signal");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Memory Isolation Check");

            @(negedge clk);
            enable = 1;
            write_en = 1;
            addr = 4'h2;
            data_in = 16'hAAAA;
            @(negedge clk);

            addr = 4'h3;
            data_in = 16'hBBBB;
            @(negedge clk);

            write_en = 0;
            read_en = 1;
            addr = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Verify Read Enable gating");

            @(negedge clk);
            enable = 1;
            write_en = 1;
            addr = 4'h7;
            data_in = 16'h7777;
            @(negedge clk);

            write_en = 0;
            read_en = 0;
            @(posedge clk);
            #1;

            if (data_out === 16'h7777) begin
                $display("FAIL: Data read while read_en was low!");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Read inhibited by read_en signal");
                pass_count = pass_count + 1;
            end
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
        $dumpvars(0,addr, clk, data_in, enable, read_en, write_en, data_out);
    end

endmodule
