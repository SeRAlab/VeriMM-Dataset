`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_rstb;
    reg i_rx_valid;
    reg i_spi_active;
    reg [2:0] vi_byte_num;
    reg [7:0] vi_data_rx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_rstb(i_rstb),
        .i_rx_valid(i_rx_valid),
        .i_spi_active(i_spi_active),
        .vi_byte_num(vi_byte_num),
        .vi_data_rx(vi_data_rx)
    );

    // Clock generation (10ns period)
    initial begin
        i_rstb = 0;
        forever #5 i_rstb = ~i_rstb;
    end

        task reset_dut;

        begin
            i_rstb = 0;
            i_rx_valid = 0;
            i_spi_active = 0;
            vi_byte_num = 3'b0;
            vi_data_rx = 8'b0;
            repeat(2) @(posedge clk);
            i_rstb = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            i_spi_active = 1;
            vi_byte_num = 3'd0;
            vi_data_rx = 8'hA5;
            @(posedge clk);
            i_rx_valid = 1;
            @(posedge clk);
            i_rx_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            i_spi_active = 1;
            vi_byte_num = 3'd2;
            vi_data_rx = 8'h5A;
            @(posedge clk);
            i_rx_valid = 1;
            @(posedge clk);
            i_rx_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            i_spi_active = 0;
            vi_byte_num = 3'd0;
            vi_data_rx = 8'hFF;
            @(posedge clk);
            i_rx_valid = 1;
            @(posedge clk);
            i_rx_valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            i_spi_active = 1;


            vi_byte_num = 3'd0;
            vi_data_rx = 8'h11;
            i_rx_valid = 1;
            @(posedge clk);
            i_rx_valid = 0;
            @(posedge clk);


            vi_byte_num = 3'd1;
            vi_data_rx = 8'h22;
            i_rx_valid = 1;
            @(posedge clk);
            i_rx_valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            i_spi_active = 1;
            vi_byte_num = 3'd0;
            vi_data_rx = 8'hCC;
            i_rx_valid = 1;
            @(posedge clk);
            i_rstb = 0;
            @(posedge clk);
            i_rstb = 1;
            repeat(2) @(posedge clk);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,i_rstb, i_rx_valid, i_spi_active, vi_byte_num, vi_data_rx);
    end

endmodule
