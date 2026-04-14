`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg avs_slave_read;
    reg avs_slave_write;
    reg [7:0] avs_slave_writedata;
    reg clk;
    reg reset;
    wire [7:0] avs_slave_readdata;
    wire reset_n;
    wire scl;
    wire sdi;
    wire sld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_slave_read(avs_slave_read),
        .avs_slave_write(avs_slave_write),
        .avs_slave_writedata(avs_slave_writedata),
        .clk(clk),
        .reset(reset),
        .avs_slave_readdata(avs_slave_readdata),
        .reset_n(reset_n),
        .scl(scl),
        .sdi(sdi),
        .sld(sld)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            avs_slave_write = 0;
            avs_slave_read = 0;
            avs_slave_writedata = 8'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 0xA5 to Avalon Slave", test_num);
            reset_dut();

            @(posedge clk);
            avs_slave_writedata = 8'hA5;
            avs_slave_write = 1;
            @(posedge clk);
            avs_slave_write = 0;



            repeat (1000) @(posedge clk);



            #1;




            check_outputs(8'h00, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 0x00 to Avalon Slave", test_num);
            reset_dut();

            @(posedge clk);
            avs_slave_writedata = 8'h00;
            avs_slave_write = 1;
            @(posedge clk);
            avs_slave_write = 0;

            repeat (1000) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 0xFF to Avalon Slave", test_num);
            reset_dut();

            @(posedge clk);
            avs_slave_writedata = 8'hFF;
            avs_slave_write = 1;
            @(posedge clk);
            avs_slave_write = 0;

            repeat (1000) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reading from Avalon Slave", test_num);
            reset_dut();

            @(posedge clk);
            avs_slave_read = 1;
            @(posedge clk);

            avs_slave_read = 0;


            #1;



            check_outputs(8'h00, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stress test - Back-to-back writes", test_num);
            reset_dut();


            @(posedge clk);
            avs_slave_writedata = 8'h55;
            avs_slave_write = 1;
            @(posedge clk);
            avs_slave_write = 0;


            repeat (100) @(posedge clk);


            @(posedge clk);
            avs_slave_writedata = 8'hAA;
            avs_slave_write = 1;
            @(posedge clk);
            avs_slave_write = 0;


            repeat (2000) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b1, 1'b0, 1'b1);
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
        input [7:0] expected_avs_slave_readdata;
        input expected_reset_n;
        input expected_scl;
        input expected_sdi;
        input expected_sld;
        begin
            if (expected_avs_slave_readdata === (expected_avs_slave_readdata ^ avs_slave_readdata ^ expected_avs_slave_readdata) &&
                expected_reset_n === (expected_reset_n ^ reset_n ^ expected_reset_n) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sdi === (expected_sdi ^ sdi ^ expected_sdi) &&
                expected_sld === (expected_sld ^ sld ^ expected_sld)) begin
                $display("PASS");
                $display("  Outputs: avs_slave_readdata=%h, reset_n=%b, scl=%b, sdi=%b, sld=%b",
                         avs_slave_readdata, reset_n, scl, sdi, sld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_slave_readdata=%h, reset_n=%b, scl=%b, sdi=%b, sld=%b",
                         expected_avs_slave_readdata, expected_reset_n, expected_scl, expected_sdi, expected_sld);
                $display("  Got:      avs_slave_readdata=%h, reset_n=%b, scl=%b, sdi=%b, sld=%b",
                         avs_slave_readdata, reset_n, scl, sdi, sld);
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
        $dumpvars(0,avs_slave_read, avs_slave_write, avs_slave_writedata, clk, reset, avs_slave_readdata, reset_n, scl, sdi, sld);
    end

endmodule
