`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg clk;
    reg [3:0] in_port;
    reg reset_n;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .in_port(in_port),
        .reset_n(reset_n),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            address = 0;
            in_port = 0;
            @(posedge clk);
            #2 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            address = 2'b00;
            in_port = 4'hA;
            @(posedge clk);


            address = 2'b00;
            in_port = 4'h0;
            @(posedge clk);

            #1 #1;
 check_outputs(32'h0000000A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 1)", test_num);
            reset_dut();


            address = 2'b01;
            in_port = 4'h5;
            @(posedge clk);


            address = 2'b01;
            in_port = 4'h0;
            @(posedge clk);

            #1 #1;
 check_outputs(32'h00000005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read-Before-Write behavior", test_num);
            reset_dut();


            address = 2'b00;
            in_port = 4'hC;
            @(posedge clk);


            address = 2'b00;
            in_port = 4'h3;
            @(posedge clk);

            #1 #1;
 check_outputs(32'h0000000C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4-bit to 32-bit Zero Extension", test_num);
            reset_dut();


            address = 2'b00;
            in_port = 4'hF;
            @(posedge clk);


            address = 2'b00;
            @(posedge clk);


            #1 #1;
 check_outputs(32'h0000000F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Independence (Addr 0 vs Addr 1)", test_num);
            reset_dut();


            address = 2'b00;
            in_port = 4'h1;
            @(posedge clk);


            address = 2'b01;
            in_port = 4'h2;
            @(posedge clk);


            address = 2'b00;
            @(posedge clk);

            #1 #1;
 check_outputs(32'h00000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, clk, in_port, reset_n, readdata);
    end

endmodule
