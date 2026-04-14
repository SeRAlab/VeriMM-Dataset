`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg miso;
    wire [7:0] data_out;
    wire mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .miso(miso),
        .data_out(data_out),
        .mosi(mosi)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data_in = 8'h00;
            miso = 0;
            @(posedge clk);


            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] to_send;
        reg [7:0] to_receive;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Transmit 0xAA, Receive 0x55", test_num);
            reset_dut();

            to_send = 8'hAA;
            to_receive = 8'h55;

            data_in = to_send;
            enable = 1;
            @(posedge clk);
            enable = 0;


            for (i = 7; i >= 0; i = i - 1) begin
                miso = to_receive[i];
                @(posedge clk);
            end



            #1;




            check_outputs(8'h55, to_send[0]);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] to_send;
        reg [7:0] to_receive;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Transmit 0x55, Receive 0xAA", test_num);
            reset_dut();

            to_send = 8'h55;
            to_receive = 8'hAA;

            data_in = to_send;
            enable = 1;
            @(posedge clk);
            enable = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = to_receive[i];
                @(posedge clk);
            end

            #1;


            check_outputs(8'hAA, to_send[0]);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] to_send;
        reg [7:0] to_receive;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Transmit 0x00, Receive 0xFF", test_num);
            reset_dut();

            to_send = 8'h00;
            to_receive = 8'hFF;

            data_in = to_send;
            enable = 1;
            @(posedge clk);
            enable = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = to_receive[i];
                @(posedge clk);
            end

            #1;


            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] to_send;
        reg [7:0] to_receive;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Transmit 0xFF, Receive 0x00", test_num);
            reset_dut();

            to_send = 8'hFF;
            to_receive = 8'h00;

            data_in = to_send;
            enable = 1;
            @(posedge clk);
            enable = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = to_receive[i];
                @(posedge clk);
            end

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] to_send;
        reg [7:0] to_receive;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Transmit 0xBE, Receive 0xEF", test_num);
            reset_dut();

            to_send = 8'hBE;
            to_receive = 8'hEF;

            data_in = to_send;
            enable = 1;
            @(posedge clk);
            enable = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = to_receive[i];
                @(posedge clk);
            end

            #1;


            check_outputs(8'hEF, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_mosi;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, mosi=%b",
                         data_out, mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, mosi=%b",
                         expected_data_out, expected_mosi);
                $display("  Got:      data_out=%h, mosi=%b",
                         data_out, mosi);
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
        $dumpvars(0,clk, data_in, enable, miso, data_out, mosi);
    end

endmodule
