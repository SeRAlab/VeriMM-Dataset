`timescale 1ns/1ps

module cache_memory_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [7:0] data_in;
    reg rw;
    wire [7:0] data_out;
    wire hit;
    wire miss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_memory dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .rw(rw),
        .data_out(data_out),
        .hit(hit),
        .miss(miss)
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
            rw = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic Write and Read Hit", test_num);
            reset_dut();
            write_op(4'hA, 8'h55);
            read_op(4'hA);
            #1;

            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Cold Miss Check", test_num);
            reset_dut();
            read_op(4'h1);
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: LRU Replacement Eviction", test_num);
            reset_dut();
            write_op(4'h1, 8'h11);
            write_op(4'h2, 8'h22);
            write_op(4'h3, 8'h33);
            write_op(4'h4, 8'h44);
            read_op(4'h1);
            write_op(4'h5, 8'h55);
            read_op(4'h2);
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: LRU Persistence Check", test_num);
            reset_dut();
            write_op(4'h1, 8'h11);
            write_op(4'h2, 8'h22);
            write_op(4'h3, 8'h33);
            write_op(4'h4, 8'h44);
            read_op(4'h1);
            write_op(4'h5, 8'h55);
            read_op(4'h1);
            #1;

            check_outputs(8'h11, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Overwriting existing address", test_num);
            reset_dut();
            write_op(4'hF, 8'hAA);
            write_op(4'hF, 8'hBB);
            read_op(4'hF);
            #1;

            check_outputs(8'hBB, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_memory Testbench");
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
        input expected_hit;
        input expected_miss;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit) &&
                expected_miss === (expected_miss ^ miss ^ expected_miss)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, hit=%b, miss=%b",
                         data_out, hit, miss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, hit=%b, miss=%b",
                         expected_data_out, expected_hit, expected_miss);
                $display("  Got:      data_out=%h, hit=%b, miss=%b",
                         data_out, hit, miss);
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
        $dumpvars(0,address, clk, data_in, rw, data_out, hit, miss);
    end

endmodule
