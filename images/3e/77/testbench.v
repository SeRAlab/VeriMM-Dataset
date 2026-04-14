`timescale 1ns/1ps

module cache_system_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg policy_select;
    reg read;
    reg reset;
    wire [3:0] data_out;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_system dut (
        .address(address),
        .clk(clk),
        .policy_select(policy_select),
        .read(read),
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
            policy_select = 0;
            read = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: FIFO Basic Hit");
            reset_dut();
            policy_select = 0;


            address = 4'h1; read = 1; @(posedge clk); #1;


            address = 4'h1; read = 1; @(posedge clk); #1;

            #1;


            check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: FIFO Eviction (First-In First-Out)");
            reset_dut();
            policy_select = 0;


            address = 4'h1; read = 1; @(posedge clk); #1;
            address = 4'h2; read = 1; @(posedge clk); #1;
            address = 4'h3; read = 1; @(posedge clk); #1;
            address = 4'h4; read = 1; @(posedge clk); #1;


            address = 4'h1; read = 1; @(posedge clk); #1;


            address = 4'h5; read = 1; @(posedge clk); #1;


            address = 4'h1; read = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'h1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: LRU Basic Hit");
            reset_dut();
            policy_select = 1;

            address = 4'hA; read = 1; @(posedge clk); #1;
            address = 4'hA; read = 1; @(posedge clk); #1;

            #1;


            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: LRU Eviction (Least Recently Used)");
            reset_dut();
            policy_select = 1;


            address = 4'h1; read = 1; @(posedge clk); #1;
            address = 4'h2; read = 1; @(posedge clk); #1;
            address = 4'h3; read = 1; @(posedge clk); #1;
            address = 4'h4; read = 1; @(posedge clk); #1;



            address = 4'h1; read = 1; @(posedge clk); #1;


            address = 4'h5; read = 1; @(posedge clk); #1;


            address = 4'h2; read = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'h2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: LRU MRU Survival");
            reset_dut();
            policy_select = 1;

            address = 4'h1; read = 1; @(posedge clk); #1;
            address = 4'h2; read = 1; @(posedge clk); #1;
            address = 4'h3; read = 1; @(posedge clk); #1;
            address = 4'h4; read = 1; @(posedge clk); #1;
            address = 4'h1; read = 1; @(posedge clk); #1;
            address = 4'h5; read = 1; @(posedge clk); #1;


            address = 4'h1; read = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'h1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_system Testbench");
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
        $dumpvars(0,address, clk, policy_select, read, reset, data_out, hit);
    end

endmodule
