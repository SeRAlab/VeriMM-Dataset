`timescale 1ns/1ps

module nvme_command_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] command_in;
    reg command_valid;
    reg rst;
    wire [15:0] command_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_register dut (
        .clk(clk),
        .command_in(command_in),
        .command_valid(command_valid),
        .rst(rst),
        .command_out(command_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            command_in = 16'h0;
            command_valid = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Command Storage", test_num);
            reset_dut();

            command_in = 16'hA5A5;
            command_valid = 1;
            @(posedge clk);
            #1;
            command_valid = 0;
            command_in = 16'h0000;

            #1;


            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Command Valid Low (Ignore Input)", test_num);
            reset_dut();

            command_in = 16'h55AA;
            command_valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Command Writes", test_num);
            reset_dut();


            command_in = 16'h1111;
            command_valid = 1;
            @(posedge clk);
            #1;


            command_in = 16'h2222;
            command_valid = 1;
            @(posedge clk);
            #1;
            command_valid = 0;

            #1;


            check_outputs(16'h2222, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value (0xFFFF)", test_num);
            reset_dut();

            command_in = 16'hFFFF;
            command_valid = 1;
            @(posedge clk);
            #1;
            command_valid = 0;

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Recovery", test_num);
            reset_dut();


            command_in = 16'h1234;
            command_valid = 1;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_register Testbench");
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
        input [15:0] expected_command_out;
        input expected_ready;
        begin
            if (expected_command_out === (expected_command_out ^ command_out ^ expected_command_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: command_out=%h, ready=%b",
                         command_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_out=%h, ready=%b",
                         expected_command_out, expected_ready);
                $display("  Got:      command_out=%h, ready=%b",
                         command_out, ready);
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
        $dumpvars(0,clk, command_in, command_valid, rst, command_out, ready);
    end

endmodule
