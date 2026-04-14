`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [255:0] rx_x;
    reg [255:0] rx_y;
    wire done;
    wire [255:0] tx_x;
    wire [255:0] tx_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rx_x(rx_x),
        .rx_y(rx_y),
        .done(done),
        .tx_x(tx_x),
        .tx_y(tx_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rx_x = 0;
            rx_y = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            rx_x = 256'h0;
            rx_y = 256'h0;
            @(posedge clk);
            #1;
            wait(done == 1'b1);
            #1;

            check_outputs(1'b1, 256'h0, 256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rx_x = 256'hA5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5;
            rx_y = 256'h1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010;
            @(posedge clk);
            #1;
            wait(done == 1'b1);

            #1;


            check_outputs(1'b1, 256'hB5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5_B5B5, 256'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            rx_x = {256{1'b1}};
            rx_y = 256'h1;
            @(posedge clk);
            #1;
            wait(done == 1'b1);

            #1;


            check_outputs(1'b1, 256'h0, 256'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            rx_x = {256{1'b1}};
            rx_y = 256'h1;
            @(posedge clk);
            #1;
            wait(done == 1'b1);



            rx_x = 256'h0;
            rx_y = 256'h0;
            @(posedge clk);
            #1;
            wait(done == 1'b1);




            #1;





            check_outputs(1'b1, 256'h1, 256'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            rx_x = {256{1'b1}};
            rx_y = {256{1'b1}};
            @(posedge clk);
            #1;
            wait(done == 1'b1);



            #1;




            check_outputs(1'b1, {255'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF, 4'hE}, 256'h1);
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
        input expected_done;
        input [255:0] expected_tx_x;
        input [255:0] expected_tx_y;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_tx_x === (expected_tx_x ^ tx_x ^ expected_tx_x) &&
                expected_tx_y === (expected_tx_y ^ tx_y ^ expected_tx_y)) begin
                $display("PASS");
                $display("  Outputs: done=%b, tx_x=%h, tx_y=%h",
                         done, tx_x, tx_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, tx_x=%h, tx_y=%h",
                         expected_done, expected_tx_x, expected_tx_y);
                $display("  Got:      done=%b, tx_x=%h, tx_y=%h",
                         done, tx_x, tx_y);
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
        $dumpvars(0,clk, reset, rx_x, rx_y, done, tx_x, tx_y);
    end

endmodule
