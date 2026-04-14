`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] inData;
    reg inValid;
    reg reset;
    wire done;
    wire [31:0] outData;
    wire outValid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inData(inData),
        .inValid(inValid),
        .reset(reset),
        .done(done),
        .outData(outData),
        .outValid(outValid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            inData = 0;
            inValid = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition (Input 100)", test_num);
            reset_dut();

            @(posedge clk);
            inData <= 32'd100;
            inValid <= 1'b1;
            @(posedge clk);
            inValid <= 1'b0;
            inData <= 32'd0;


            wait(done === 1'b1);


            #1;



            check_outputs(1'b1, 32'd101, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow check (Input 0xFFFFFFFF)", test_num);
            reset_dut();

            @(posedge clk);
            inData <= 32'hFFFFFFFF;
            inValid <= 1'b1;
            @(posedge clk);
            inValid <= 1'b0;

            wait(done === 1'b1);


            #1;



            check_outputs(1'b1, 32'h00000000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero input check", test_num);
            reset_dut();

            @(posedge clk);
            inData <= 32'h0;
            inValid <= 1'b1;
            @(posedge clk);
            inValid <= 1'b0;

            wait(done === 1'b1);


            #1;



            check_outputs(1'b1, 32'h1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pattern check (Input 0x12345678)", test_num);
            reset_dut();

            @(posedge clk);
            inData <= 32'h12345678;
            inValid <= 1'b1;
            @(posedge clk);
            inValid <= 1'b0;

            wait(done === 1'b1);


            #1;



            check_outputs(1'b1, 32'h12345679, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large value (Input 0xAAAAAAAA)", test_num);
            reset_dut();

            @(posedge clk);
            inData <= 32'hAAAAAAAA;
            inValid <= 1'b1;
            @(posedge clk);
            inValid <= 1'b0;

            wait(done === 1'b1);


            #1;



            check_outputs(1'b1, 32'hAAAAAAAB, 1'b0);
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
        input expected_done;
        input [31:0] expected_outData;
        input expected_outValid;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_outData === (expected_outData ^ outData ^ expected_outData) &&
                expected_outValid === (expected_outValid ^ outValid ^ expected_outValid)) begin
                $display("PASS");
                $display("  Outputs: done=%b, outData=%h, outValid=%b",
                         done, outData, outValid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, outData=%h, outValid=%b",
                         expected_done, expected_outData, expected_outValid);
                $display("  Got:      done=%b, outData=%h, outValid=%b",
                         done, outData, outValid);
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
        $dumpvars(0,clk, inData, inValid, reset, done, outData, outValid);
    end

endmodule
