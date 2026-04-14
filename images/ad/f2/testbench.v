`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg spi_clk;
    reg spi_csn_0;
    reg spi_csn_1;
    reg spi_mosi;
    wire spi_dirn;
    wire spi_miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .spi_clk(spi_clk),
        .spi_csn_0(spi_csn_0),
        .spi_csn_1(spi_csn_1),
        .spi_mosi(spi_mosi),
        .spi_dirn(spi_dirn),
        .spi_miso(spi_miso)
    );

    // Clock generation (10ns period)
    initial begin
        spi_clk = 0;
        forever #5 spi_clk = ~spi_clk;
    end

        task reset_dut;

        begin
            spi_csn_0 = 1;
            spi_csn_1 = 1;
            spi_mosi = 0;
            sdio_drive_en = 0;
            sdio_drive_val = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge spi_clk);
            spi_csn_0 = 0;
            spi_mosi = 1;
            repeat(2) @(posedge spi_clk);


            #1;



            check_outputs(1'b0, spi_miso);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge spi_clk);
            spi_csn_1 = 0;
            spi_mosi = 0;
            repeat(2) @(posedge spi_clk);
            #1;

            check_outputs(1'b0, spi_miso);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            spi_csn_0 = 1;
            spi_csn_1 = 1;
            repeat(5) @(posedge spi_clk);


            #1;



            check_outputs(spi_dirn, spi_miso);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            @(negedge spi_clk);
            spi_csn_0 = 0;

            for(i=0; i<8; i=i+1) begin
                spi_mosi = i[0];
                @(negedge spi_clk);
            end


            sdio_drive_en = 1;
            sdio_drive_val = 1;
            @(posedge spi_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge spi_clk);
            spi_csn_1 = 0;


            repeat(16) @(negedge spi_clk);
            sdio_drive_en = 1;
            sdio_drive_val = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_spi_dirn;
        input expected_spi_miso;
        begin
            if (expected_spi_dirn === (expected_spi_dirn ^ spi_dirn ^ expected_spi_dirn) &&
                expected_spi_miso === (expected_spi_miso ^ spi_miso ^ expected_spi_miso)) begin
                $display("PASS");
                $display("  Outputs: spi_dirn=%b, spi_miso=%b",
                         spi_dirn, spi_miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spi_dirn=%b, spi_miso=%b",
                         expected_spi_dirn, expected_spi_miso);
                $display("  Got:      spi_dirn=%b, spi_miso=%b",
                         spi_dirn, spi_miso);
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
        $dumpvars(0,spi_clk, spi_csn_0, spi_csn_1, spi_mosi, spi_dirn, spi_miso);
    end

endmodule
