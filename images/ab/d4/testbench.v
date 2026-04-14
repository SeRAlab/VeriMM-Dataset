`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg [10:0] vga_h;
    reg [10:0] vga_v;
    reg [15:0] write_address;
    wire pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .vga_h(vga_h),
        .vga_v(vga_v),
        .write_address(write_address),
        .pixel_out(pixel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            write_address = 16'h0;
            data_in = 16'h0;
            vga_h = 11'h0;
            vga_v = 11'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 1 to address 0 and read at coordinate (0,0)", test_num);
            reset_dut();


            @(posedge clk);
            load = 1;
            write_address = 16'h0000;
            data_in = 16'h0001;
            @(posedge clk);


            load = 0;
            vga_h = 11'd0;
            vga_v = 11'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0 to address 0 and read at coordinate (0,0)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            write_address = 16'h0000;
            data_in = 16'h0000;
            @(posedge clk);

            load = 0;
            vga_h = 11'd0;
            vga_v = 11'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 1 to address 0x000F and read at coordinate (15,0)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            write_address = 16'h000F;
            data_in = 16'h0001;
            @(posedge clk);

            load = 0;
            vga_h = 11'd15;
            vga_v = 11'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 1 to address 0x0100 and read at coordinate (0,1)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            write_address = 16'h0100;
            data_in = 16'h0001;
            @(posedge clk);

            load = 0;
            vga_h = 11'd0;
            vga_v = 11'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ensure writing to addr B doesn't corrupt addr A", test_num);
            reset_dut();


            @(posedge clk);
            load = 1;
            write_address = 16'h0000;
            data_in = 16'h0001;
            @(posedge clk);


            write_address = 16'h0001;
            data_in = 16'h0000;
            @(posedge clk);


            load = 0;
            vga_h = 11'd0;
            vga_v = 11'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 1 to address 0xFFFF and read at (255,255)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            write_address = 16'hFFFF;
            data_in = 16'h0001;
            @(posedge clk);

            load = 0;
            vga_h = 11'd255;
            vga_v = 11'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_pixel_out;
        begin
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%b",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%b",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%b",
                         pixel_out);
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
        $dumpvars(0,clk, data_in, load, vga_h, vga_v, write_address, pixel_out);
    end

endmodule
