`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [7:0] data_in_0;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    reg [7:0] data_in_3;
    reg enable;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .enable(enable),
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
            rst = 1;
            channel_select = 0;
            enable = 0;
            data_in_0 = 8'h00;
            data_in_1 = 8'h00;
            data_in_2 = 8'h00;
            data_in_3 = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset and Idle Check");
            test_num = 1;
            reset_dut();
            enable = 0;
            channel_select = 2'b00;
            data_in_0 = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Channel 0 Transfer");
            test_num = 2;
            reset_dut();
            enable = 1;
            channel_select = 2'b00;
            data_in_0 = 8'h11;
            data_in_1 = 8'h22;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Channel 1 Transfer");
            test_num = 3;
            reset_dut();
            enable = 1;
            channel_select = 2'b01;
            data_in_1 = 8'hBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Channel 2 Transfer");
            test_num = 4;
            reset_dut();
            enable = 1;
            channel_select = 2'b10;
            data_in_2 = 8'hCC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Channel 3 Transfer");
            test_num = 5;
            reset_dut();
            enable = 1;
            channel_select = 2'b11;
            data_in_3 = 8'hDD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Enable Signal Logic");
            test_num = 6;
            reset_dut();

            enable = 1;
            channel_select = 2'b00;
            data_in_0 = 8'h55;
            @(posedge clk);

            enable = 0;
            data_in_0 = 8'hFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Channel Switching");
            test_num = 7;
            reset_dut();
            enable = 1;
            data_in_0 = 8'h01;
            data_in_1 = 8'h02;
            data_in_2 = 8'h03;
            data_in_3 = 8'h04;

            channel_select = 2'b00; @(posedge clk);
            channel_select = 2'b01; @(posedge clk);
            channel_select = 2'b10; @(posedge clk);
            channel_select = 2'b11; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        $dumpvars(0,channel_select, clk, data_in_0, data_in_1, data_in_2, data_in_3, enable, rst, data_out);
    end

endmodule
