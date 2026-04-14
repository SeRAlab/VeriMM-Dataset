`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg MISO;
    reg clk;
    reg [7:0] data_in;
    reg reset_n;
    reg start;
    wire CS;
    wire MOSI;
    wire SCK;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .MISO(MISO),
        .clk(clk),
        .data_in(data_in),
        .reset_n(reset_n),
        .start(start),
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            start = 0;
            data_in = 0;
            MISO = 0;
            #20;
            reset_n = 1;
            #20;
        end
        endtask
    task spi_slave_respond;

        input [7:0] data_to_slave_send;
        integer i;
        begin
            wait(CS == 0);

            MISO = data_to_slave_send[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge SCK);
                MISO = data_to_slave_send[i];
            end
            @(posedge CS);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Basic Transmission - Transmit 0xAA, Receive 0x55");
            reset_dut();
            data_in = 8'hAA;
            test_num = 1;

            #10 start = 1;
            #10 start = 0;


            spi_slave_respond(8'h55);

            #20;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Inverse Pattern - Transmit 0x55, Receive 0xAA");
            reset_dut();
            data_in = 8'h55;
            test_num = 2;

            #10 start = 1;
            #10 start = 0;

            spi_slave_respond(8'hAA);

            #20;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All High - Transmit 0xFF, Receive 0xFF");
            reset_dut();
            data_in = 8'hFF;
            test_num = 3;

            #10 start = 1;
            #10 start = 0;

            spi_slave_respond(8'hFF);

            #20;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All Low - Transmit 0x00, Receive 0x00");
            reset_dut();
            data_in = 8'h00;
            test_num = 4;

            #10 start = 1;
            #10 start = 0;

            spi_slave_respond(8'h00);

            #20;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Random Data - Transmit 0xA5, Receive 0x12");
            reset_dut();
            data_in = 8'hA5;
            test_num = 5;

            #10 start = 1;
            #10 start = 0;

            spi_slave_respond(8'h12);

            #20;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 8'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
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
        input expected_CS;
        input expected_MOSI;
        input expected_SCK;
        input [7:0] expected_data_out;
        begin
            if (expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SCK === (expected_SCK ^ SCK ^ expected_SCK) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: CS=%b, MOSI=%b, SCK=%b, data_out=%h",
                         CS, MOSI, SCK, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CS=%b, MOSI=%b, SCK=%b, data_out=%h",
                         expected_CS, expected_MOSI, expected_SCK, expected_data_out);
                $display("  Got:      CS=%b, MOSI=%b, SCK=%b, data_out=%h",
                         CS, MOSI, SCK, data_out);
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
        $dumpvars(0,MISO, clk, data_in, reset_n, start, CS, MOSI, SCK, data_out);
    end

endmodule
