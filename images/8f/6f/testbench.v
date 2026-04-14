`timescale 1ns/1ps

module parallel_load_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 0;
        data_in = 8'h00;
        @(posedge clk);
        #1;
    end
    endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Load AA");
        test_num = test_num + 1;
        reset_dut();

        data_in = 8'hAA;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        #1;


        check_outputs(8'hAA);
    end
    endtask

    task testcase002;

    begin
        $display("Testcase 002: Hold Value (Load=0)");
        test_num = test_num + 1;
        reset_dut();


        data_in = 8'h55;
        load = 1;
        @(posedge clk);
        #1;


        data_in = 8'hFF;
        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h55);
    end
    endtask

    task testcase003;

    begin
        $display("Testcase 003: Overwrite Value");
        test_num = test_num + 1;
        reset_dut();


        data_in = 8'h11;
        load = 1;
        @(posedge clk);
        #1;


        data_in = 8'h22;
        load = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h22);
    end
    endtask

    task testcase004;

    begin
        $display("Testcase 004: Load All High (FF)");
        test_num = test_num + 1;
        reset_dut();

        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hFF);
    end
    endtask

    task testcase005;

    begin
        $display("Testcase 005: Multiple Cycles Hold");
        test_num = test_num + 1;
        reset_dut();


        data_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;


        load = 0;
        data_in = 8'h00;
        @(posedge clk);
        #1;
        data_in = 8'hFF;
        @(posedge clk);
        #1;
        data_in = 8'h33;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hA5);
    end
    endtask

    task testcase006;

    begin
        $display("Testcase 006: Load All Low (00)");
        test_num = test_num + 1;
        reset_dut();


        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1;


        data_in = 8'h00;
        load = 1;
        @(posedge clk);
        #1;

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
        $display("parallel_load_register Testbench");
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
        $dumpvars(0,clk, data_in, load, data_out);
    end

endmodule
