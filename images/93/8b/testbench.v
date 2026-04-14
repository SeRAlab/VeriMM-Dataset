`timescale 1ns/1ps

module register8bit_sync_reset_tb;

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
    register8bit_sync_reset dut (
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
        @(posedge clk);
        rst <= 1;
        load <= 0;
        data_in <= 8'h00;
        @(posedge clk);
        rst <= 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying synchronous reset...", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying basic load operation (0xA5)...", test_num);
        reset_dut();

        @(posedge clk);
        load <= 1;
        data_in <= 8'hA5;
        @(posedge clk);
        load <= 0;
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying data retention (Hold) when load is low...", test_num);
        reset_dut();


        @(posedge clk);
        load <= 1;
        data_in <= 8'h55;
        @(posedge clk);


        load <= 0;
        data_in <= 8'hAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying reset priority over load signal...", test_num);
        reset_dut();

        @(posedge clk);
        rst <= 1;
        load <= 1;
        data_in <= 8'hFF;
        @(posedge clk);
        rst <= 0;
        load <= 0;
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying consecutive load operations...", test_num);
        reset_dut();

        @(posedge clk);
        load <= 1;
        data_in <= 8'h11;
        @(posedge clk);
        data_in <= 8'h22;
        @(posedge clk);
        data_in <= 8'h33;
        @(posedge clk);
        load <= 0;
        #1;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verifying load of boundary value 0xFF...", test_num);
        reset_dut();

        @(posedge clk);
        load <= 1;
        data_in <= 8'hFF;
        @(posedge clk);
        load <= 0;
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register8bit_sync_reset Testbench");
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
        $dumpvars(0,clk, data_in, load, rst, data_out);
    end

endmodule
