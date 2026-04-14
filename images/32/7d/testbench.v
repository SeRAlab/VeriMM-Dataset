`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg miso;
    reg reset;
    reg start;
    wire cs;
    wire [7:0] data_out;
    wire mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .miso(miso),
        .reset(reset),
        .start(start),
        .cs(cs),
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
            reset = 1;
            start = 0;
            data_in = 8'h00;
            miso = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        reg [7:0] send_val;
        reg [7:0] recv_val;
        integer i;
        begin
            test_num = test_num + 1;
            send_val = 8'hA5;
            recv_val = 8'h5A;
            $display("\nRunning testcase%03d: Sending %h, Receiving %h", test_num, send_val, recv_val);
            reset_dut();

            @(posedge clk);
            #1;
            data_in = send_val;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            while (cs == 1) @(posedge clk);


            for (i = 7; i >= 0; i = i - 1) begin
                miso = recv_val[i];
                @(posedge clk);
            end


            while (cs == 0) @(posedge clk);
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b1, recv_val, send_val[0]);
        end
        endtask

    task testcase002;

        reg [7:0] send_val;
        reg [7:0] recv_val;
        integer i;
        begin
            test_num = test_num + 1;
            send_val = 8'h00;
            recv_val = 8'hFF;
            $display("\nRunning testcase%03d: Sending %h, Receiving %h", test_num, send_val, recv_val);
            reset_dut();

            @(posedge clk);
            #1;
            data_in = send_val;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (cs == 1) @(posedge clk);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = recv_val[i];
                @(posedge clk);
            end

            while (cs == 0) @(posedge clk);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, recv_val, send_val[0]);
        end
        endtask

    task testcase003;

        reg [7:0] send_val;
        reg [7:0] recv_val;
        integer i;
        begin
            test_num = test_num + 1;
            send_val = 8'hFF;
            recv_val = 8'h00;
            $display("\nRunning testcase%03d: Sending %h, Receiving %h", test_num, send_val, recv_val);
            reset_dut();

            @(posedge clk);
            #1;
            data_in = send_val;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (cs == 1) @(posedge clk);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = recv_val[i];
                @(posedge clk);
            end

            while (cs == 0) @(posedge clk);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, recv_val, send_val[0]);
        end
        endtask

    task testcase004;

        reg [7:0] send_val;
        reg [7:0] recv_val;
        integer i;
        begin
            test_num = test_num + 1;
            send_val = 8'h12;
            recv_val = 8'h34;
            $display("\nRunning testcase%03d: Sending %h, Receiving %h", test_num, send_val, recv_val);
            reset_dut();

            @(posedge clk);
            #1;
            data_in = send_val;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (cs == 1) @(posedge clk);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = recv_val[i];
                @(posedge clk);
            end

            while (cs == 0) @(posedge clk);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, recv_val, send_val[0]);
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
        input expected_cs;
        input [7:0] expected_data_out;
        input expected_mosi;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, data_out=%h, mosi=%b",
                         cs, data_out, mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, data_out=%h, mosi=%b",
                         expected_cs, expected_data_out, expected_mosi);
                $display("  Got:      cs=%b, data_out=%h, mosi=%b",
                         cs, data_out, mosi);
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
        $dumpvars(0,clk, data_in, miso, reset, start, cs, data_out, mosi);
    end

endmodule
