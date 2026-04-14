`timescale 1ns/1ps

module cache_lru_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg read;
    reg reset;
    reg write;
    wire [7:0] data_out;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_lru dut (
        .address(address),
        .clk(clk),
        .read(read),
        .reset(reset),
        .write(write),
        .data_out(data_out),
        .hit(hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 8'h00;
            read = 0;
            write = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Cold Start Read Miss");
            reset_dut();
            address = 8'hAA;
            read = 1;
            write = 0;
            @(posedge clk);
            #1;
            read = 0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write then Read Hit");
            reset_dut();

            address = 8'h11;
            write = 1;
            read = 0;
            @(posedge clk);
            #1;
            write = 0;


            address = 8'h11;
            read = 1;
            @(posedge clk);
            #1;
            read = 0;
            #1;

            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Fill Cache Capacity");
            reset_dut();

            address = 8'h01; write = 1; @(posedge clk); #1;
            address = 8'h02; write = 1; @(posedge clk); #1;
            address = 8'h03; write = 1; @(posedge clk); #1;
            address = 8'h04; write = 1; @(posedge clk); #1;
            write = 0;


            address = 8'h01;
            read = 1;
            @(posedge clk);
            #1;
            read = 0;
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Basic LRU Eviction");
            reset_dut();

            address = 8'h01; write = 1; @(posedge clk); #1;
            address = 8'h02; write = 1; @(posedge clk); #1;
            address = 8'h03; write = 1; @(posedge clk); #1;
            address = 8'h04; write = 1; @(posedge clk); #1;


            address = 8'h05; write = 1; @(posedge clk); #1;
            write = 0;


            address = 8'h01;
            read = 1;
            @(posedge clk);
            #1;
            read = 0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: LRU Update on Access");
            reset_dut();

            address = 8'h01; write = 1; @(posedge clk); #1;
            address = 8'h02; write = 1; @(posedge clk); #1;
            address = 8'h03; write = 1; @(posedge clk); #1;
            address = 8'h04; write = 1; @(posedge clk); #1;
            write = 0;



            address = 8'h01; read = 1; @(posedge clk); #1;
            read = 0;


            address = 8'h05; write = 1; @(posedge clk); #1;
            write = 0;


            address = 8'h02;
            read = 1;
            @(posedge clk);
            #1;
            read = 0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple Replacements");
            reset_dut();

            address = 8'h01; write = 1; @(posedge clk); #1;
            address = 8'h02; write = 1; @(posedge clk); #1;
            address = 8'h03; write = 1; @(posedge clk); #1;
            address = 8'h04; write = 1; @(posedge clk); #1;


            address = 8'h05; write = 1; @(posedge clk); #1;
            address = 8'h06; write = 1; @(posedge clk); #1;
            write = 0;


            address = 8'h03;
            read = 1;
            @(posedge clk);
            #1;
            read = 0;
            #1;

            check_outputs(8'h03, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_lru Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_hit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, hit=%b",
                         data_out, hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, hit=%b",
                         expected_data_out, expected_hit);
                $display("  Got:      data_out=%h, hit=%b",
                         data_out, hit);
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
        $dumpvars(0,address, clk, read, reset, write, data_out, hit);
    end

endmodule
