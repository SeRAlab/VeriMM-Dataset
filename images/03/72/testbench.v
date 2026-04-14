`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg ss;
    wire [7:0] data_out;
    wire mosi;
    wire transmission_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .ss(ss),
        .data_out(data_out),
        .mosi(mosi),
        .transmission_complete(transmission_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ss = 1;
            data_in = 8'h00;
            miso = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] master_send;
        reg [7:0] slave_send;
        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Data 0xA5", test_num);
            reset_dut();

            master_send = 8'hA5;
            slave_send  = 8'h3C;

            data_in = master_send;
            ss = 0;


            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                @(posedge clk);
            end

            wait(transmission_complete == 1);
            #2;




            #1;





            check_outputs(slave_send, master_send[0], 1'b1);
            ss = 1;
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] master_send;
        reg [7:0] slave_send;
        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Data 0x00", test_num);
            reset_dut();

            master_send = 8'h00;
            slave_send  = 8'hFF;

            data_in = master_send;
            ss = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                @(posedge clk);
            end

            wait(transmission_complete == 1);
            #2;
            #1;

            check_outputs(slave_send, master_send[0], 1'b1);
            ss = 1;
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] master_send;
        reg [7:0] slave_send;
        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Data 0xFF", test_num);
            reset_dut();

            master_send = 8'hFF;
            slave_send  = 8'h55;

            data_in = master_send;
            ss = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                @(posedge clk);
            end

            wait(transmission_complete == 1);
            #2;
            #1;

            check_outputs(slave_send, master_send[0], 1'b1);
            ss = 1;
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] master_send;
        reg [7:0] slave_send;
        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Data 0x55", test_num);
            reset_dut();

            master_send = 8'h55;
            slave_send  = 8'hAA;

            data_in = master_send;
            ss = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                @(posedge clk);
            end

            wait(transmission_complete == 1);
            #2;
            #1;

            check_outputs(slave_send, master_send[0], 1'b1);
            ss = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Idle State Check", test_num);
            reset_dut();

            data_in = 8'hFF;
            ss = 1;
            miso = 1;

            #100;


            #1;



            check_outputs(8'h00, 1'bx, 1'b0);
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
        input expected_mosi;
        input expected_transmission_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_transmission_complete === (expected_transmission_complete ^ transmission_complete ^ expected_transmission_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, mosi=%b, transmission_complete=%b",
                         data_out, mosi, transmission_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, mosi=%b, transmission_complete=%b",
                         expected_data_out, expected_mosi, expected_transmission_complete);
                $display("  Got:      data_out=%h, mosi=%b, transmission_complete=%b",
                         data_out, mosi, transmission_complete);
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
        $dumpvars(0,clk, data_in, reset, ss, data_out, mosi, transmission_complete);
    end

endmodule
