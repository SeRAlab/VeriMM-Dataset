`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs_n;
    reg mosi;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs_n(cs_n),
        .mosi(mosi),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs_n = 1;
            mosi = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] val;
        integer i;
        begin

            @(posedge clk);
            cs_n = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = val[i];
                @(negedge clk);
            end
            #2 cs_n = 1;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: 0xAA");
            reset_dut();
            send_byte(8'hAA);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: 0x55");
            reset_dut();
            send_byte(8'h55);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: 0xFF");
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: 0x00");
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: 0xC3");
            reset_dut();
            send_byte(8'hC3);
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase006: 0x1E");
            reset_dut();
            send_byte(8'h1E);
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Running Testcase007: CS_N Gating Test");
            reset_dut();


            cs_n = 1;
            for (i = 0; i < 8; i = i + 1) begin
                mosi = 1;
                @(negedge clk);
            end


            send_byte(8'h4B);
            #1;

            check_outputs(8'h4B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        $dumpvars(0,clk, cs_n, mosi, data_out);
    end

endmodule
