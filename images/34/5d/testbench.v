`timescale 1ns/1ps

module cache_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg select_policy;
    reg wr_en;
    wire [3:0] cache_status;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_controller dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .select_policy(select_policy),
        .wr_en(wr_en),
        .cache_status(cache_status),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            address = 0;
            data_in = 0;
            wr_en = 0;
            select_policy = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: FIFO Fill and Status Check...");
            reset_dut();
            select_policy = 0;
            write_cache(4'h1, 8'hAA);
            write_cache(4'h2, 8'hBB);
            write_cache(4'h3, 8'hCC);
            write_cache(4'h4, 8'hDD);
            read_cache(4'h4);
            #1;

            check_outputs(4'hF, 8'hDD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: FIFO Replacement (Evict First)...");
            reset_dut();
            select_policy = 0;
            write_cache(4'h1, 8'h11);
            write_cache(4'h2, 8'h22);
            write_cache(4'h3, 8'h33);
            write_cache(4'h4, 8'h44);
            write_cache(4'h5, 8'h55);

            read_cache(4'h1);


            read_cache(4'h5);
            #1;

            check_outputs(4'hF, 8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: LRU Replacement (Evict Least Recently Used)...");
            reset_dut();
            select_policy = 1;
            write_cache(4'h1, 8'h11);
            write_cache(4'h2, 8'h22);
            write_cache(4'h3, 8'h33);
            write_cache(4'h4, 8'h44);

            read_cache(4'h1);

            write_cache(4'h5, 8'h55);

            read_cache(4'h1);
            #1;

            check_outputs(4'hF, 8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Hit Update...");
            reset_dut();
            write_cache(4'hA, 8'h10);
            write_cache(4'hA, 8'hFF);
            read_cache(4'hA);
            #1;

            check_outputs(4'h1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Behavior...");
            reset_dut();
            write_cache(4'h1, 8'hAA);
            write_cache(4'h2, 8'hBB);
            reset_dut();
            read_cache(4'h1);
            #1;

            check_outputs(4'h0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_controller Testbench");
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
        input [3:0] expected_cache_status;
        input [7:0] expected_data_out;
        begin
            if (expected_cache_status === (expected_cache_status ^ cache_status ^ expected_cache_status) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: cache_status=%h, data_out=%h",
                         cache_status, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cache_status=%h, data_out=%h",
                         expected_cache_status, expected_data_out);
                $display("  Got:      cache_status=%h, data_out=%h",
                         cache_status, data_out);
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
        $dumpvars(0,address, clk, data_in, rst, select_policy, wr_en, cache_status, data_out);
    end

endmodule
