`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] app_msi_num;
    reg app_msi_req;
    reg [2:0] app_msi_tc;
    reg clk_in;
    reg rstn;
    reg stream_ready;
    wire app_msi_ack;
    wire [7:0] stream_data;
    wire stream_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .app_msi_num(app_msi_num),
        .app_msi_req(app_msi_req),
        .app_msi_tc(app_msi_tc),
        .clk_in(clk_in),
        .rstn(rstn),
        .stream_ready(stream_ready),
        .app_msi_ack(app_msi_ack),
        .stream_data(stream_data),
        .stream_valid(stream_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rstn = 0;
            app_msi_req = 0;
            app_msi_tc = 3'b0;
            app_msi_num = 5'b0;
            stream_ready = 0;
            #20;
            rstn = 1;
            @(posedge clk_in);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            app_msi_req = 1;
            app_msi_tc = 3'b101;
            app_msi_num = 5'b01010;
            stream_ready = 1;



            repeat(2) @(posedge clk_in);
            #2;

            #1;


            check_outputs(1'b1, 8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            app_msi_req = 1;
            app_msi_tc = 3'b010;
            app_msi_num = 5'b01111;
            stream_ready = 1;


            repeat(2) @(posedge clk_in);
            #2;

            #1;


            check_outputs(1'b1, 8'h4F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            app_msi_req = 1;
            app_msi_tc = 3'b111;
            app_msi_num = 5'b11111;
            stream_ready = 1;


            repeat(2) @(posedge clk_in);
            #2;

            #1;


            check_outputs(1'b1, 8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            app_msi_req = 1;
            app_msi_tc = 3'b101;
            app_msi_num = 5'b10101;
            stream_ready = 0;


            repeat(2) @(posedge clk_in);
            #2;




            #1;





            check_outputs(1'b0, 8'hAD, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            app_msi_req = 1;
            app_msi_tc = 3'b001;
            app_msi_num = 5'b00001;
            stream_ready = 0;

            @(posedge clk_in);
            #2;

            if(app_msi_ack !== 0 || stream_valid !== 0) $display("Error: Premature ack/valid");

            @(posedge clk_in);
            stream_ready = 1;


            repeat(2) @(posedge clk_in);
            #2;


            #1;



            check_outputs(1'b1, 8'h21, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            app_msi_req = 1;
            app_msi_tc = 3'b111;
            app_msi_num = 5'b11111;
            stream_ready = 1;

            @(posedge clk_in);
            rstn = 0;
            #10;


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
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
        testcase006();
        
        
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
        input expected_app_msi_ack;
        input [7:0] expected_stream_data;
        input expected_stream_valid;
        begin
            if (expected_app_msi_ack === (expected_app_msi_ack ^ app_msi_ack ^ expected_app_msi_ack) &&
                expected_stream_data === (expected_stream_data ^ stream_data ^ expected_stream_data) &&
                expected_stream_valid === (expected_stream_valid ^ stream_valid ^ expected_stream_valid)) begin
                $display("PASS");
                $display("  Outputs: app_msi_ack=%b, stream_data=%h, stream_valid=%b",
                         app_msi_ack, stream_data, stream_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: app_msi_ack=%b, stream_data=%h, stream_valid=%b",
                         expected_app_msi_ack, expected_stream_data, expected_stream_valid);
                $display("  Got:      app_msi_ack=%b, stream_data=%h, stream_valid=%b",
                         app_msi_ack, stream_data, stream_valid);
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
        $dumpvars(0,app_msi_num, app_msi_req, app_msi_tc, clk_in, rstn, stream_ready, app_msi_ack, stream_data, stream_valid);
    end

endmodule
