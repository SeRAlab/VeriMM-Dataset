`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] data_in;
    reg mosi;
    reg reset;
    wire [7:0] data_out;
    wire data_ready;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .mosi(mosi),
        .reset(reset),
        .data_out(data_out),
        .data_ready(data_ready),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs = 1;
            mosi = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] send_val;
        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Master sends 0xA5, Slave sends 0x00", test_num);
            send_val = 8'hA5;
            data_in = 8'h00;
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = send_val[i];
                @(posedge clk);
            end

            #2;

            #1;


            check_outputs(8'hA5, 1'b1, 1'b0);
            cs = 1;
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] send_val;
        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Master sends 0x5A, Slave sends 0xFF", test_num);
            send_val = 8'h5A;
            data_in = 8'hFF;
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = send_val[i];
                @(posedge clk);
            end

            #2;

            #1;


            check_outputs(8'h5A, 1'b1, 1'b1);
            cs = 1;
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] send_val;
        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Master sends 0xFF, Slave sends 0xAA", test_num);
            send_val = 8'hFF;
            data_in = 8'hAA;
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = send_val[i];
                @(posedge clk);
            end

            #2;

            #1;


            check_outputs(8'hFF, 1'b1, 1'b0);
            cs = 1;
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] send_val;
        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Master sends 0x00, Slave sends 0x55", test_num);
            send_val = 8'h00;
            data_in = 8'h55;
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = send_val[i];
                @(posedge clk);
            end

            #2;

            #1;


            check_outputs(8'h00, 1'b1, 1'b1);
            cs = 1;
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: CS inactive test", test_num);
            cs = 1;
            data_in = 8'hFF;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = 1'b1;
                @(posedge clk);
            end

            #2;

            #1;


            check_outputs(8'h00, 1'b0, miso);
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
        input expected_data_ready;
        input expected_miso;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b, miso=%b",
                         data_out, data_ready, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b, miso=%b",
                         expected_data_out, expected_data_ready, expected_miso);
                $display("  Got:      data_out=%h, data_ready=%b, miso=%b",
                         data_out, data_ready, miso);
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
        $dumpvars(0,clk, cs, data_in, mosi, reset, data_out, data_ready, miso);
    end

endmodule
