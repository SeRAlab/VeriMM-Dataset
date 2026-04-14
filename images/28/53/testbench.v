`timescale 1ns/1ps

module LRU_Cache_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg clk;
    reg [3:0] data_in;
    reg request;
    reg reset;
    wire [3:0] data_out;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LRU_Cache dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .request(request),
        .reset(reset),
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
            address = 0;
            data_in = 0;
            request = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Cold Miss check");
            reset_dut();
            address = 2'b10;
            request = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Write and Read back Hit");
            reset_dut();

            address = 2'b01;
            data_in = 4'hA;
            request = 1'b1;
            @(posedge clk);

            address = 2'b01;
            request = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Filling all 4 lines");
            reset_dut();

            address = 2'b00; data_in = 4'h1; request = 1'b1; @(posedge clk);
            address = 2'b01; data_in = 4'h2; request = 1'b1; @(posedge clk);
            address = 2'b10; data_in = 4'h3; request = 1'b1; @(posedge clk);
            address = 2'b11; data_in = 4'h4; request = 1'b1; @(posedge clk);


            address = 2'b00;
            request = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Update existing address data");
            reset_dut();

            address = 2'b11;
            data_in = 4'hE;
            request = 1'b1;
            @(posedge clk);

            address = 2'b11;
            data_in = 4'hF;
            request = 1'b1;
            @(posedge clk);

            address = 2'b11;
            request = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset effect on valid data");
            reset_dut();

            address = 2'b10;
            data_in = 4'h7;
            request = 1'b1;
            @(posedge clk);

            address = 2'b10;
            request = 1'b0;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;

            address = 2'b10;
            request = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LRU_Cache Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, request, reset, data_out, hit);
    end

endmodule
