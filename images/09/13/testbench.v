`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg wr_enable;
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
        .wr_enable(wr_enable),
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
            wr_enable = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            wr_enable = 1;
            addr = 4'h0;
            data_in = 16'hABCD;
            @(negedge clk);

            wr_enable = 0;
            addr = 4'h0;
            @(negedge clk);
            $display("Testcase %0d: Basic Write/Read at Addr 0", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            wr_enable = 1;
            addr = 4'hF;
            data_in = 16'h1234;
            @(negedge clk);

            wr_enable = 0;
            addr = 4'hF;
            @(negedge clk);
            $display("Testcase %0d: Basic Write/Read at Addr 15", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            wr_enable = 1; addr = 4'h2; data_in = 16'hAAAA;
            @(negedge clk);

            wr_enable = 1; addr = 4'h3; data_in = 16'h5555;
            @(negedge clk);

            wr_enable = 0; addr = 4'h2;
            @(negedge clk);
            $display("Testcase %0d: Address Isolation Check (Read Addr 2)", test_num);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            wr_enable = 1; addr = 4'h5; data_in = 16'h1111;
            @(negedge clk);

            wr_enable = 1; addr = 4'h5; data_in = 16'hFFFF;
            @(negedge clk);

            wr_enable = 0; addr = 4'h5;
            @(negedge clk);
            $display("Testcase %0d: Overwrite Data at Addr 5", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            wr_enable = 1; addr = 4'hA; data_in = 16'h0000;
            @(negedge clk);

            wr_enable = 0; addr = 4'hA;
            @(negedge clk);
            if (data_out !== 16'h0000) begin
                $display("Testcase %0d Part A: All Zeros FAIL", test_num);
            end


            wr_enable = 1; addr = 4'hB; data_in = 16'hFFFF;
            @(negedge clk);

            wr_enable = 0; addr = 4'hB;
            @(negedge clk);
            $display("Testcase %0d: Data Patterns All 0s/1s", test_num);
            #1;

            check_outputs(16'hFFFF);
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
        $dumpvars(0,addr, clk, data_in, wr_enable, data_out);
    end

endmodule
