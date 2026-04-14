`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg refclk;
    reg reset_n;
    wire [7:0] data;
    wire hsync;
    wire pixclk;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .refclk(refclk),
        .reset_n(reset_n),
        .data(data),
        .hsync(hsync),
        .pixclk(pixclk),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        refclk = 0;
        forever #5 refclk = ~refclk;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            refclk = 1'b0;
            #20;
            reset_n = 1'b1;
            #10;
            @(posedge refclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Increment and Pixclk Tracking", test_num);
            reset_dut();

            repeat(5) @(posedge refclk);

            @(negedge refclk);



            #1;




            check_outputs(8'h05, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: HSYNC Transition Check", test_num);
            reset_dut();

            repeat(100) @(posedge refclk);
            @(negedge refclk);


            #1;



            check_outputs(8'h64, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: VSYNC Long Duration Check", test_num);
            reset_dut();

            repeat(1000) @(posedge refclk);
            @(negedge refclk);


            #1;



            check_outputs(8'hE8, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-operation Reset Recovery", test_num);
            reset_dut();
            repeat(50) @(posedge refclk);

            reset_n = 1'b0;
            #20;
            reset_n = 1'b1;
            @(posedge refclk);
            @(negedge refclk);

            #1;


            check_outputs(8'h01, 1'b1, 1'b0, 1'b1);
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
        input [7:0] expected_data;
        input expected_hsync;
        input expected_pixclk;
        input expected_vsync;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_pixclk === (expected_pixclk ^ pixclk ^ expected_pixclk) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: data=%h, hsync=%b, pixclk=%b, vsync=%b",
                         data, hsync, pixclk, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, hsync=%b, pixclk=%b, vsync=%b",
                         expected_data, expected_hsync, expected_pixclk, expected_vsync);
                $display("  Got:      data=%h, hsync=%b, pixclk=%b, vsync=%b",
                         data, hsync, pixclk, vsync);
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
        $dumpvars(0,refclk, reset_n, data, hsync, pixclk, vsync);
    end

endmodule
