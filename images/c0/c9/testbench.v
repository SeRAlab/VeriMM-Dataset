`timescale 1ns/1ps

module fm_raw_fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk_core;
    reg [31:0] i_check_address;
    reg [31:0] i_dt;
    reg i_renable;
    reg i_wstrobe;
    reg rst_x;
    wire [4:0] o_dnum;
    wire [31:0] o_dt;
    wire o_empty;
    wire o_full;
    wire o_hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_raw_fifo dut (
        .clk_core(clk_core),
        .i_check_address(i_check_address),
        .i_dt(i_dt),
        .i_renable(i_renable),
        .i_wstrobe(i_wstrobe),
        .rst_x(rst_x),
        .o_dnum(o_dnum),
        .o_dt(o_dt),
        .o_empty(o_empty),
        .o_full(o_full),
        .o_hit(o_hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk_core = 0;
        forever #5 clk_core = ~clk_core;
    end

        task reset_dut;

        begin
            rst_x = 1'b0;
            i_check_address = 32'h0;
            i_dt = 32'h0;
            i_renable = 1'b0;
            i_wstrobe = 1'b0;
            @(posedge clk_core);
            #1 rst_x = 1'b1;
            @(posedge clk_core);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state check", test_num);
            reset_dut();

            #1;


            check_outputs(5'd0, 32'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single write check", test_num);
            reset_dut();
            @(posedge clk_core);
            i_wstrobe = 1'b1;
            i_dt = 32'hABCD_EF01;
            @(posedge clk_core);
            #1 i_wstrobe = 1'b0;

            #1;


            check_outputs(5'd0, 32'hABCD_EF01, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Fill to full check", test_num);
            reset_dut();
            for(i=0; i<DEPTH; i=i+1) begin
                @(posedge clk_core);
                i_wstrobe = 1'b1;
                i_dt = i + 1;
            end
            @(posedge clk_core);
            #1 i_wstrobe = 1'b0;

            #1;


            check_outputs(5'd0, 32'h1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Write 2 and Read back", test_num);
            reset_dut();

            @(posedge clk_core);
            i_wstrobe = 1'b1; i_dt = 32'd100;
            @(posedge clk_core);

            i_dt = 32'd200;
            @(posedge clk_core);
            i_wstrobe = 1'b0;


            i_renable = 1'b1;
            @(posedge clk_core);
            #1;
            i_renable = 1'b0;


            #1;



            check_outputs(5'd0, 32'd200, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Hit detection check (True)", test_num);
            reset_dut();
            @(posedge clk_core);
            i_wstrobe = 1'b1; i_dt = 32'h55AA_55AA;
            @(posedge clk_core);
            i_wstrobe = 1'b0;
            i_check_address = 32'h55AA_55AA;
            #1;

            #1;


            check_outputs(5'd0, 32'h55AA_55AA, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Hit detection check (False)", test_num);
            reset_dut();
            @(posedge clk_core);
            i_wstrobe = 1'b1; i_dt = 32'h1111_1111;
            @(posedge clk_core);
            i_wstrobe = 1'b0;
            i_check_address = 32'hEEEE_EEEE;
            #1;

            #1;


            check_outputs(5'd0, 32'h1111_1111, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %03d: Rollover check", test_num);
            reset_dut();

            for(i=0; i<DEPTH; i=i+1) begin
                @(posedge clk_core);
                i_wstrobe = 1'b1; i_dt = i;
            end
            @(posedge clk_core);
            i_wstrobe = 1'b0; i_renable = 1'b1;
            repeat(DEPTH) @(posedge clk_core);
            #1 i_renable = 1'b0;


            @(posedge clk_core);
            i_wstrobe = 1'b1; i_dt = 32'h99;
            @(posedge clk_core);
            #1 i_wstrobe = 1'b0;

            #1;


            check_outputs(5'd0, 32'h99, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_raw_fifo Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_o_dnum;
        input [31:0] expected_o_dt;
        input expected_o_empty;
        input expected_o_full;
        input expected_o_hit;
        begin
            if (expected_o_dnum === (expected_o_dnum ^ o_dnum ^ expected_o_dnum) &&
                expected_o_dt === (expected_o_dt ^ o_dt ^ expected_o_dt) &&
                expected_o_empty === (expected_o_empty ^ o_empty ^ expected_o_empty) &&
                expected_o_full === (expected_o_full ^ o_full ^ expected_o_full) &&
                expected_o_hit === (expected_o_hit ^ o_hit ^ expected_o_hit)) begin
                $display("PASS");
                $display("  Outputs: o_dnum=%h, o_dt=%h, o_empty=%b, o_full=%b, o_hit=%b",
                         o_dnum, o_dt, o_empty, o_full, o_hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dnum=%h, o_dt=%h, o_empty=%b, o_full=%b, o_hit=%b",
                         expected_o_dnum, expected_o_dt, expected_o_empty, expected_o_full, expected_o_hit);
                $display("  Got:      o_dnum=%h, o_dt=%h, o_empty=%b, o_full=%b, o_hit=%b",
                         o_dnum, o_dt, o_empty, o_full, o_hit);
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
        $dumpvars(0,clk_core, i_check_address, i_dt, i_renable, i_wstrobe, rst_x, o_dnum, o_dt, o_empty, o_full, o_hit);
    end

endmodule
