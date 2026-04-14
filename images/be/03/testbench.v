`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [4:0] count;
    reg [127:0] data;
    reg enable;
    reg picready;
    reg reset;
    reg spiclockn;
    reg spiclockp;
    wire done;
    wire sclk;
    wire sdo;
    wire starting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .count(count),
        .data(data),
        .enable(enable),
        .picready(picready),
        .reset(reset),
        .spiclockn(spiclockn),
        .spiclockp(spiclockp),
        .done(done),
        .sclk(sclk),
        .sdo(sdo),
        .starting(starting)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data = 0;
            count = 0;
            picready = 0;
            spiclockp = 0;
            spiclockn = 1;
            repeat (5) @(posedge clock);
            reset = 0;
            repeat (2) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Transmitting 8 bits", test_num);
            reset_dut();

            data = 128'hAA;
            count = 5'd8;
            picready = 1;
            enable = 1;
            @(posedge clock);
            enable = 0;




            repeat (100) @(posedge clock);




            #1;





            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transmitting 31 bits", test_num);
            reset_dut();

            data = 128'hFFFF_FFFF;
            count = 5'd31;
            picready = 1;
            enable = 1;
            @(posedge clock);
            enable = 0;


            repeat (200) @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: No enable pulse check", test_num);
            reset_dut();

            data = 128'h12345678;
            count = 5'd16;
            picready = 1;
            enable = 0;

            repeat (50) @(posedge clock);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transmitting 4 bits with alternating pattern", test_num);
            reset_dut();

            data = 128'hF;
            count = 5'd4;
            picready = 1;
            enable = 1;
            @(posedge clock);
            enable = 0;

            repeat (50) @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Minimal 1-bit transmission", test_num);
            reset_dut();

            data = 128'h1;
            count = 5'd1;
            picready = 1;
            enable = 1;
            @(posedge clock);
            enable = 0;

            repeat (30) @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
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
        input expected_sclk;
        input expected_sdo;
        input expected_starting;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk) &&
                expected_sdo === (expected_sdo ^ sdo ^ expected_sdo) &&
                expected_starting === (expected_starting ^ starting ^ expected_starting)) begin
                $display("PASS");
                $display("  Outputs: done=%b, sclk=%b, sdo=%b, starting=%b",
                         done, sclk, sdo, starting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, sclk=%b, sdo=%b, starting=%b",
                         expected_done, expected_sclk, expected_sdo, expected_starting);
                $display("  Got:      done=%b, sclk=%b, sdo=%b, starting=%b",
                         done, sclk, sdo, starting);
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
        $dumpvars(0,clock, count, data, enable, picready, reset, spiclockn, spiclockp, done, sclk, sdo, starting);
    end

endmodule
