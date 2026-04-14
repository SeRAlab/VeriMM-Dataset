`timescale 1ns/1ps

module wb_flash_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [7:0] flash_dat_i;
    reg nrst_i;
    reg [18:0] wb_adr_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat_i;
    reg [3:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [18:0] flash_adr_o;
    wire flash_ce;
    wire [7:0] flash_dat_o;
    wire flash_oe;
    wire flash_we;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wb_flash dut (
        .clk_i(clk_i),
        .flash_dat_i(flash_dat_i),
        .nrst_i(nrst_i),
        .wb_adr_i(wb_adr_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .flash_adr_o(flash_adr_o),
        .flash_ce(flash_ce),
        .flash_dat_o(flash_dat_o),
        .flash_oe(flash_oe),
        .flash_we(flash_we),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            nrst_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            wb_adr_i = 0;
            wb_dat_i = 0;
            wb_sel_i = 0;
            flash_dat_i = 0;
            repeat (2) @(posedge clk_i);
            nrst_i = 1;
            repeat (2) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(19'h0, 1'b1, 8'h0, 1'b1, 1'b1, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Basic Read Operation", test_num);
            reset_dut();

            @(posedge clk_i);
            wb_adr_i = 19'h12345;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            wb_sel_i = 4'b0001;
            flash_dat_i = 8'hA5;


            wait(wb_ack_o == 1'b1);
            @(posedge clk_i);



            #1;




            check_outputs(19'h12345, 1'b0, 8'h0, 1'b0, 1'b1, 1'b1, 32'h000000A5);

            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Basic Write Operation", test_num);
            reset_dut();

            @(posedge clk_i);
            wb_adr_i = 19'h54321;
            wb_dat_i = 32'hDEADBEEF;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 1;
            wb_sel_i = 4'b0001;


            wait(wb_ack_o == 1'b1);
            @(posedge clk_i);


            #1;



            check_outputs(19'h54321, 1'b0, 8'hEF, 1'b1, 1'b0, 1'b1, 32'h0);

            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Consecutive Read and Write", test_num);
            reset_dut();


            @(posedge clk_i);
            wb_adr_i = 19'h01010;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            flash_dat_i = 8'h55;
            wait(wb_ack_o == 1'b1);
            @(posedge clk_i);


            wb_adr_i = 19'h02020;
            wb_dat_i = 32'hAA;
            wb_we_i  = 1;
            wait(wb_ack_o == 1'b1);
            @(posedge clk_i);


            #1;



            check_outputs(19'h02020, 1'b0, 8'hAA, 1'b1, 1'b0, 1'b1, 32'h0);

            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Max Address Check", test_num);
            reset_dut();

            @(posedge clk_i);
            wb_adr_i = 19'h7FFFF;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            flash_dat_i = 8'hFF;

            wait(wb_ack_o == 1'b1);
            @(posedge clk_i);


            #1;



            check_outputs(19'h7FFFF, 1'b0, 8'h0, 1'b0, 1'b1, 1'b1, 32'h000000FF);

            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wb_flash Testbench");
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
        input [18:0] expected_flash_adr_o;
        input expected_flash_ce;
        input [7:0] expected_flash_dat_o;
        input expected_flash_oe;
        input expected_flash_we;
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        begin
            if (expected_flash_adr_o === (expected_flash_adr_o ^ flash_adr_o ^ expected_flash_adr_o) &&
                expected_flash_ce === (expected_flash_ce ^ flash_ce ^ expected_flash_ce) &&
                expected_flash_dat_o === (expected_flash_dat_o ^ flash_dat_o ^ expected_flash_dat_o) &&
                expected_flash_oe === (expected_flash_oe ^ flash_oe ^ expected_flash_oe) &&
                expected_flash_we === (expected_flash_we ^ flash_we ^ expected_flash_we) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: flash_adr_o=%h, flash_ce=%b, flash_dat_o=%h, flash_oe=%b, flash_we=%b, wb_ack_o=%b, wb_dat_o=%h",
                         flash_adr_o, flash_ce, flash_dat_o, flash_oe, flash_we, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flash_adr_o=%h, flash_ce=%b, flash_dat_o=%h, flash_oe=%b, flash_we=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_flash_adr_o, expected_flash_ce, expected_flash_dat_o, expected_flash_oe, expected_flash_we, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      flash_adr_o=%h, flash_ce=%b, flash_dat_o=%h, flash_oe=%b, flash_we=%b, wb_ack_o=%b, wb_dat_o=%h",
                         flash_adr_o, flash_ce, flash_dat_o, flash_oe, flash_we, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,clk_i, flash_dat_i, nrst_i, wb_adr_i, wb_cyc_i, wb_dat_i, wb_sel_i, wb_stb_i, wb_we_i, flash_adr_o, flash_ce, flash_dat_o, flash_oe, flash_we, wb_ack_o, wb_dat_o);
    end

endmodule
