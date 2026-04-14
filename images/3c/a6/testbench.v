`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg wr_en;
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
        .wr_en(wr_en),
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
            wr_en = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read to Address 0");
            reset_dut();


            @(posedge clk);
            addr = 4'h0;
            data_in = 16'hABCD;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;

            @(posedge clk);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read to Address 15");
            reset_dut();


            @(posedge clk);
            addr = 4'hF;
            data_in = 16'h1234;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;

            @(posedge clk);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting data at Address 7");
            reset_dut();


            @(posedge clk);
            addr = 4'h7;
            data_in = 16'hAAAA;
            wr_en = 1;


            @(posedge clk);
            data_in = 16'h5555;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;

            @(posedge clk);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify data is not written when wr_en is 0");
            reset_dut();


            @(posedge clk);
            addr = 4'h5;
            data_in = 16'hEEEE;
            wr_en = 1;


            @(posedge clk);
            data_in = 16'h9999;
            wr_en = 0;

            @(posedge clk);

            #1;


            check_outputs(16'hEEEE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple sequential writes and read back");
            reset_dut();


            @(posedge clk);
            addr = 4'h1; data_in = 16'h0001; wr_en = 1;

            @(posedge clk);
            addr = 4'h2; data_in = 16'h0002; wr_en = 1;

            @(posedge clk);
            addr = 4'h3; data_in = 16'h0003; wr_en = 1;


            @(posedge clk);
            wr_en = 0;
            addr = 4'h2;

            @(posedge clk);
            #1;

            check_outputs(16'h0002);
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
        $dumpvars(0,addr, clk, data_in, wr_en, data_out);
    end

endmodule
