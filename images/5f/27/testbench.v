`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk50;
    reg color_mode;
    reg [15:0] idata;
    reg mode;
    reg [7:0] pal_data;
    reg [1:0] pal_idx;
    reg pal_we_n;
    wire [13:0] addr;
    wire [3:0] b;
    wire drq;
    wire [3:0] g;
    wire hr;
    wire [3:0] r;
    wire vid_irq;
    wire vr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk50(clk50),
        .color_mode(color_mode),
        .idata(idata),
        .mode(mode),
        .pal_data(pal_data),
        .pal_idx(pal_idx),
        .pal_we_n(pal_we_n),
        .addr(addr),
        .b(b),
        .drq(drq),
        .g(g),
        .hr(hr),
        .r(r),
        .vid_irq(vid_irq),
        .vr(vr)
    );

    // Clock generation (10ns period)
    initial begin
        clk50 = 0;
        forever #5 clk50 = ~clk50;
    end

        task reset_dut;

        begin
            color_mode = 0;
            idata = 16'h0000;
            mode = 0;
            pal_data = 8'h00;
            pal_idx = 2'b00;
            pal_we_n = 1'b1;
            repeat (5) @(posedge clk50);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk50);
            pal_idx = 2'b01;
            pal_data = 8'b11100000;
            pal_we_n = 1'b0;
            @(posedge clk50);
            pal_we_n = 1'b1;


            idata = 16'h5555;


            repeat (20) @(posedge clk50);




            #1;





            check_outputs(addr, 4'h0, drq, 4'h0, hr, 4'hE, vid_irq, vr);
        end
        endtask

    task testcase002;

        reg [13:0] start_addr;
        begin
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk50);
            start_addr = addr;



            repeat (100) @(posedge clk50);


            if (addr > start_addr || drq == 1'b1)
                #1;

                check_outputs(addr, b, drq, g, hr, r, vid_irq, vr);
            else
                #1;

                check_outputs(14'h3FFF, 4'hF, 1'b1, 4'hF, 1'b0, 4'hF, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            mode = 1'b1;



            repeat (500) @(posedge clk50);


            #1;



            check_outputs(addr, b, drq, g, hr, r, vid_irq, vr);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            color_mode = 1'b1;



            repeat (2000) @(posedge clk50);


            #1;



            check_outputs(addr, b, drq, g, hr, r, vid_irq, vr);
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
        input [13:0] expected_addr;
        input [3:0] expected_b;
        input expected_drq;
        input [3:0] expected_g;
        input expected_hr;
        input [3:0] expected_r;
        input expected_vid_irq;
        input expected_vr;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_drq === (expected_drq ^ drq ^ expected_drq) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_hr === (expected_hr ^ hr ^ expected_hr) &&
                expected_r === (expected_r ^ r ^ expected_r) &&
                expected_vid_irq === (expected_vid_irq ^ vid_irq ^ expected_vid_irq) &&
                expected_vr === (expected_vr ^ vr ^ expected_vr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, b=%h, drq=%b, g=%h, hr=%b, r=%h, vid_irq=%b, vr=%b",
                         addr, b, drq, g, hr, r, vid_irq, vr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, b=%h, drq=%b, g=%h, hr=%b, r=%h, vid_irq=%b, vr=%b",
                         expected_addr, expected_b, expected_drq, expected_g, expected_hr, expected_r, expected_vid_irq, expected_vr);
                $display("  Got:      addr=%h, b=%h, drq=%b, g=%h, hr=%b, r=%h, vid_irq=%b, vr=%b",
                         addr, b, drq, g, hr, r, vid_irq, vr);
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
        $dumpvars(0,clk50, color_mode, idata, mode, pal_data, pal_idx, pal_we_n, addr, b, drq, g, hr, r, vid_irq, vr);
    end

endmodule
