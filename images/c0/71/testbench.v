`timescale 1ns/1ps

module ziptimer_tb;

    // Testbench signals (sequential circuit)
    reg i_ce;
    reg i_clk;
    reg i_rst;
    reg i_wb_cyc;
    reg [31:0] i_wb_data;
    reg i_wb_stb;
    reg i_wb_we;
    wire o_int;
    wire o_wb_ack;
    wire [31:0] o_wb_data;
    wire o_wb_stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ziptimer dut (
        .i_ce(i_ce),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_wb_cyc(i_wb_cyc),
        .i_wb_data(i_wb_data),
        .i_wb_stb(i_wb_stb),
        .i_wb_we(i_wb_we),
        .o_int(o_int),
        .o_wb_ack(o_wb_ack),
        .o_wb_data(o_wb_data),
        .o_wb_stall(o_wb_stall)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rst = 1;
            i_ce = 0;
            i_wb_cyc = 0;
            i_wb_stb = 0;
            i_wb_we = 0;
            i_wb_data = 0;
            repeat(5) @(posedge i_clk);
            i_rst = 0;
            @(posedge i_clk);
        end
        endtask
    task wb_read_start;

        begin
            @(posedge i_clk);
            i_wb_cyc <= 1;
            i_wb_stb <= 1;
            i_wb_we  <= 0;
        end
        endtask

    task wb_read_end;

        begin
            while (!o_wb_ack) @(posedge i_clk);
            @(posedge i_clk);
            i_wb_cyc <= 0;
            i_wb_stb <= 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: One-shot countdown to zero", test_num);
            reset_dut();

            wb_write(32'h5);
            i_ce = 1;

            repeat(10) @(posedge i_clk);

            #1;


            check_outputs(1'b1, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Clock Enable gating", test_num);
            reset_dut();

            wb_write(32'hA);
            i_ce = 0;
            repeat(10) @(posedge i_clk);

            wb_read_start();
            while(!o_wb_ack) @(posedge i_clk);

            #1;


            check_outputs(1'b0, 1'b1, 32'hA, 1'b0);
            wb_read_end();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Read current value mid-countdown", test_num);
            reset_dut();

            wb_write(32'd20);
            i_ce = 1;

            repeat(5) @(posedge i_clk);
            wb_read_start();
            while(!o_wb_ack) @(posedge i_clk);


            #1;



            check_outputs(1'b0, 1'b1, 32'd15, 1'b0);
            wb_read_end();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Auto-Reload mode operation", test_num);
            reset_dut();

            wb_write(32'h8000_0003);
            i_ce = 1;

            repeat(4) @(posedge i_clk);

            repeat(2) @(posedge i_clk);
            wb_read_start();
            while(!o_wb_ack) @(posedge i_clk);

            #1;


            check_outputs(1'b0, 1'b1, 32'h8000_0001, 1'b0);
            wb_read_end();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ziptimer Testbench");
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
        input expected_o_int;
        input expected_o_wb_ack;
        input [31:0] expected_o_wb_data;
        input expected_o_wb_stall;
        begin
            if (expected_o_int === (expected_o_int ^ o_int ^ expected_o_int) &&
                expected_o_wb_ack === (expected_o_wb_ack ^ o_wb_ack ^ expected_o_wb_ack) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data) &&
                expected_o_wb_stall === (expected_o_wb_stall ^ o_wb_stall ^ expected_o_wb_stall)) begin
                $display("PASS");
                $display("  Outputs: o_int=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         o_int, o_wb_ack, o_wb_data, o_wb_stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_int=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         expected_o_int, expected_o_wb_ack, expected_o_wb_data, expected_o_wb_stall);
                $display("  Got:      o_int=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         o_int, o_wb_ack, o_wb_data, o_wb_stall);
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
        $dumpvars(0,i_ce, i_clk, i_rst, i_wb_cyc, i_wb_data, i_wb_stb, i_wb_we, o_int, o_wb_ack, o_wb_data, o_wb_stall);
    end

endmodule
