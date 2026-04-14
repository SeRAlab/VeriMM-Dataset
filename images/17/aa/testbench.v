`timescale 1ns/1ps

module pipeline_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Propagation (0x10 -> 0x11)", test_num);
            reset_dut();

            data_in = 8'h10;
            @(posedge clk); #1;
            data_in = 8'h20;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Overflow Handling (0xFF -> 0x00)", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk); #1;
            data_in = 8'h00;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Continuous Stream", test_num);
            reset_dut();

            data_in = 8'h01; @(posedge clk); #1;
            data_in = 8'h02; @(posedge clk); #1;
            data_in = 8'h03; @(posedge clk); #1;

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Input (0x00 -> 0x01)", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk); #1;
            data_in = 8'hEE;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Mid-operation", test_num);
            reset_dut();

            data_in = 8'h55;
            @(posedge clk); #1;


            reset = 1;
            #5;
            reset = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_register Testbench");
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
