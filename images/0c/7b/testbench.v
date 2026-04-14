`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [7:0] data_out;
    wire tx_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .data_out(data_out),
        .tx_enable(tx_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: Single Byte Transmission (0xAA)", test_num);
            reset_dut();
            data_in = 8'hAA;
            valid_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: Idle State Check", test_num);
            reset_dut();
            valid_in = 0;
            data_in = 8'hFF;
            @(posedge clk);
            #1;



            #1;




            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: Multi-byte Burst Transmission", test_num);
            reset_dut();
            valid_in = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h44, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: Zero Data Transmission", test_num);
            reset_dut();
            data_in = 8'h00;
            valid_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %03d: All-Ones Data Transmission", test_num);
            reset_dut();
            data_in = 8'hFF;
            valid_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning Testcase %03d: Valid Signal Toggle Check", test_num);
            reset_dut();

            data_in = 8'h55;
            valid_in = 1;
            @(posedge clk);

            valid_in = 0;
            data_in = 8'h66;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_tx_enable;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_tx_enable === (expected_tx_enable ^ tx_enable ^ expected_tx_enable)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, tx_enable=%b",
                         data_out, tx_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, tx_enable=%b",
                         expected_data_out, expected_tx_enable);
                $display("  Got:      data_out=%h, tx_enable=%b",
                         data_out, tx_enable);
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
        $dumpvars(0,clk, data_in, rst, valid_in, data_out, tx_enable);
    end

endmodule
