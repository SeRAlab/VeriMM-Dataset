`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] command;
    reg cs;
    reg [7:0] data;
    reg mosi;
    reg start;
    wire miso;
    wire [7:0] received_data;
    wire [7:0] sent_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .command(command),
        .cs(cs),
        .data(data),
        .mosi(mosi),
        .start(start),
        .miso(miso),
        .received_data(received_data),
        .sent_data(sent_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            cs = 1;
            mosi = 0;
            command = 8'h00;
            data = 8'h00;
            #20;
        end
        endtask
    task testcase001;

        integer i;
        reg [15:0] mosi_stream;
        begin
            test_num = 1;
            reset_dut();



            command = 8'hA5;
            data = 8'h5A;
            mosi_stream = 16'h1234;

            @(posedge clk);
            #1;
            cs = 0;
            start = 1;

            @(posedge clk);
            #1;
            start = 0;



            for (i = 15; i >= 0; i = i - 1) begin
                mosi = mosi_stream[i];
                @(posedge clk);
                #1;
            end


            #5;



            #1;




            check_outputs(1'b0, 8'h34, 8'h5A);

            cs = 1;
            #20;
        end
        endtask

    task testcase002;

        integer i;
        reg [15:0] mosi_stream;
        begin
            test_num = 2;
            reset_dut();

            command = 8'hFF;
            data = 8'h00;
            mosi_stream = 16'hABCD;

            @(posedge clk);
            #1;
            cs = 0;
            start = 1;

            @(posedge clk);
            #1;
            start = 0;

            for (i = 15; i >= 0; i = i - 1) begin
                mosi = mosi_stream[i];
                @(posedge clk);
                #1;
            end

            #5;

            #1;


            check_outputs(1'b0, 8'hCD, 8'h00);

            cs = 1;
            #20;
        end
        endtask

    task testcase003;

        integer i;
        reg [15:0] mosi_stream;
        begin
            test_num = 3;
            reset_dut();

            command = 8'h00;
            data = 8'hFF;
            mosi_stream = 16'hFFFF;

            @(posedge clk);
            #1;
            cs = 0;
            start = 1;

            @(posedge clk);
            #1;
            start = 0;

            for (i = 15; i >= 0; i = i - 1) begin
                mosi = mosi_stream[i];
                @(posedge clk);
                #1;
            end

            #5;

            #1;


            check_outputs(1'b1, 8'hFF, 8'hFF);

            cs = 1;
            #20;
        end
        endtask

    task testcase004;

        integer i;
        reg [15:0] mosi_stream;
        begin
            test_num = 4;
            reset_dut();

            command = 8'hAA;
            data = 8'hCC;
            mosi_stream = 16'h5555;

            @(posedge clk);
            #1;
            cs = 0;
            start = 1;

            @(posedge clk);
            #1;
            start = 0;

            for (i = 15; i >= 0; i = i - 1) begin
                mosi = mosi_stream[i];
                @(posedge clk);
                #1;
            end

            #5;

            #1;


            check_outputs(1'b0, 8'h55, 8'hCC);

            cs = 1;
            #20;
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
        input expected_miso;
        input [7:0] expected_received_data;
        input [7:0] expected_sent_data;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_received_data === (expected_received_data ^ received_data ^ expected_received_data) &&
                expected_sent_data === (expected_sent_data ^ sent_data ^ expected_sent_data)) begin
                $display("PASS");
                $display("  Outputs: miso=%b, received_data=%h, sent_data=%h",
                         miso, received_data, sent_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b, received_data=%h, sent_data=%h",
                         expected_miso, expected_received_data, expected_sent_data);
                $display("  Got:      miso=%b, received_data=%h, sent_data=%h",
                         miso, received_data, sent_data);
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
        $dumpvars(0,clk, command, cs, data, mosi, start, miso, received_data, sent_data);
    end

endmodule
