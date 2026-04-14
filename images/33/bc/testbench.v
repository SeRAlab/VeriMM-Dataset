`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [31:0] data_in;
    reg [31:0] dest_address;
    reg reset;
    reg [31:0] source_address;
    reg start;
    wire [31:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .dest_address(dest_address),
        .reset(reset),
        .source_address(source_address),
        .start(start),
        .data_out(data_out),
        .done(done)
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
            channel_select = 2'b00;
            data_in = 32'h0;
            source_address = 32'h0;
            dest_address = 32'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Channel 0 Basic Transfer");
            reset_dut();


            channel_select = 2'b00;
            source_address = 32'h1000_0000;
            dest_address   = 32'h2000_0000;
            data_in        = 32'hABCD_1234;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(32'hABCD_1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Channel 1 Basic Transfer");
            reset_dut();


            channel_select = 2'b01;
            source_address = 32'h3000_0000;
            dest_address   = 32'h4000_0000;
            data_in        = 32'h55AA_55AA;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(32'h55AA_55AA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Channel 2 Basic Transfer");
            reset_dut();


            channel_select = 2'b10;
            source_address = 32'h5000_0000;
            dest_address   = 32'h6000_0000;
            data_in        = 32'hDEAD_BEEF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Channel 3 Basic Transfer");
            reset_dut();


            channel_select = 2'b11;
            source_address = 32'h7000_0000;
            dest_address   = 32'h8000_0000;
            data_in        = 32'hFFFF_FFFF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Zero Data Transfer");
            reset_dut();

            channel_select = 2'b00;
            source_address = 32'h0000_0000;
            dest_address   = 32'hFFFF_FFFF;
            data_in        = 32'h0000_0000;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Idle State Check after Reset");
            reset_dut();


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,channel_select, clk, data_in, dest_address, reset, source_address, start, data_out, done);
    end

endmodule
