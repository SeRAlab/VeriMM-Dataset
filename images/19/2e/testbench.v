`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command;
    reg reset;
    wire [7:0] data;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .command(command),
        .reset(reset),
        .data(data),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            command = 4'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Command 0x5 Request");
            reset_dut();
            @(posedge clk);
            command = 4'h5;
            @(posedge clk);
            command = 4'h0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Command 0xA Request");
            reset_dut();
            @(posedge clk);
            command = 4'hA;
            @(posedge clk);
            command = 4'h0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h0A, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Maximum Command 0xF");
            reset_dut();
            @(posedge clk);
            command = 4'hF;
            @(posedge clk);
            command = 4'h0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h0F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Minimum Command 0x1");
            reset_dut();
            @(posedge clk);
            command = 4'h1;
            @(posedge clk);
            command = 4'h0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Data Persistence Check");
            reset_dut();
            @(posedge clk);
            command = 4'h7;
            @(posedge clk);
            command = 4'h0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h07, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [7:0] expected_data;
        input expected_ready;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data=%h, ready=%b",
                         data, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, ready=%b",
                         expected_data, expected_ready);
                $display("  Got:      data=%h, ready=%b",
                         data, ready);
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
        $dumpvars(0,clk, command, reset, data, ready);
    end

endmodule
