`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg mosi;
    reg reset;
    wire [7:0] data_out;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .mosi(mosi),
        .reset(reset),
        .data_out(data_out),
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
        enable = 0;
        data_in = 8'h00;
        mosi = 0;
        @(posedge clk);
        #1;
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

        integer i;
        reg [7:0] send_data;
        reg [7:0] recv_pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Transaction (Send 0xA5, Receive 0x5A)", test_num);
            reset_dut();

            send_data = 8'hA5;
            recv_pattern = 8'h5A;
            data_in = send_data;
            enable = 1;


            for (i = 7; i >= 0; i = i - 1) begin
                mosi = recv_pattern[i];
                @(posedge clk);
            end

            enable = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] send_data;
        reg [7:0] recv_pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Check (Send 0x00, Receive 0xFF)", test_num);
            reset_dut();

            send_data = 8'h00;
            recv_pattern = 8'hFF;
            data_in = send_data;
            enable = 1;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = recv_pattern[i];
                @(posedge clk);
            end

            enable = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] send_data;
        reg [7:0] recv_pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern (Send 0xFF, Receive 0xAA)", test_num);
            reset_dut();

            send_data = 8'hFF;
            recv_pattern = 8'hAA;
            data_in = send_data;
            enable = 1;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = recv_pattern[i];
                @(posedge clk);
            end

            enable = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle/Enable Check", test_num);
            reset_dut();

            data_in = 8'h12;
            enable = 0;
            mosi = 1;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
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
        input expected_miso;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, miso=%b",
                         data_out, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, miso=%b",
                         expected_data_out, expected_miso);
                $display("  Got:      data_out=%h, miso=%b",
                         data_out, miso);
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
        $dumpvars(0,clk, data_in, enable, mosi, reset, data_out, miso);
    end

endmodule
