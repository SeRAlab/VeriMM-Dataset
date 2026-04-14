`timescale 1ns/1ps

module reg_unit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_unit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 0;
        load = 0;
        data_in = 8'h00;
        @(negedge clk);
        rst = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Basic Load 0xAA");
        reset_dut();
        data_in = 8'hAA;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Basic Load 0x55");
        reset_dut();
        data_in = 8'h55;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Verify Hold (load=0)");
        reset_dut();

        data_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #2;

        load = 0;
        data_in = 8'hFF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Load All Zeros");
        reset_dut();
        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #2;
        data_in = 8'h00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Load All Ones (0xFF)");
        reset_dut();
        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Consecutive Updates");
        reset_dut();
        load = 1;
        data_in = 8'h11;
        @(posedge clk);
        #2;
        data_in = 8'h22;
        @(posedge clk);
        #2;
        data_in = 8'h33;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: Reset Override");
        reset_dut();
        data_in = 8'hCC;
        load = 1;
        @(posedge clk);
        #2;

        rst = 0;
        #2;

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
        $display("reg_unit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, data_in, load, rst, data_out);
    end

endmodule
