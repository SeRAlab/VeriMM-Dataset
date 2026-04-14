`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [17:0] ctl1;
    reg [17:0] ctl2;
    reg [17:0] ctl3;
    reg [17:0] ctl4;
    reg iobus_cono_clear;
    reg iobus_cono_set;
    reg iobus_datao_clear;
    reg iobus_datao_set;
    reg iobus_iob_fm_datai;
    reg iobus_iob_fm_status;
    reg [35:0] iobus_iob_in;
    reg iobus_iob_poweron;
    reg iobus_iob_reset;
    reg [6:0] iobus_ios;
    reg iobus_rdi_pulse;
    reg reset;
    wire iobus_dr_split;
    wire [35:0] iobus_iob_out;
    wire [6:0] iobus_pi_req;
    wire iobus_rdi_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctl1(ctl1),
        .ctl2(ctl2),
        .ctl3(ctl3),
        .ctl4(ctl4),
        .iobus_cono_clear(iobus_cono_clear),
        .iobus_cono_set(iobus_cono_set),
        .iobus_datao_clear(iobus_datao_clear),
        .iobus_datao_set(iobus_datao_set),
        .iobus_iob_fm_datai(iobus_iob_fm_datai),
        .iobus_iob_fm_status(iobus_iob_fm_status),
        .iobus_iob_in(iobus_iob_in),
        .iobus_iob_poweron(iobus_iob_poweron),
        .iobus_iob_reset(iobus_iob_reset),
        .iobus_ios(iobus_ios),
        .iobus_rdi_pulse(iobus_rdi_pulse),
        .reset(reset),
        .iobus_dr_split(iobus_dr_split),
        .iobus_iob_out(iobus_iob_out),
        .iobus_pi_req(iobus_pi_req),
        .iobus_rdi_data(iobus_rdi_data)
    );
    task testcase001;



        begin
            test_num = 1;
            $display("\nTest Case %0d: System Reset", test_num);


            clk = 0;
            reset = 1;
            iobus_iob_poweron = 0;
            iobus_iob_reset = 0;
            iobus_datao_clear = 0;
            iobus_datao_set = 0;
            iobus_cono_clear = 0;
            iobus_cono_set = 0;
            iobus_iob_fm_datai = 0;
            iobus_iob_fm_status = 0;
            iobus_rdi_pulse = 0;
            iobus_ios = 7'b0000000;
            iobus_iob_in = 36'h0;
            ctl1 = 18'h0;
            ctl2 = 18'h0;
            ctl3 = 18'h0;
            ctl4 = 18'h0;

            repeat(2) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 36'h0, 7'h0, 1'b0);
        end
        endtask

    task testcase002;



        begin
            test_num = 2;
            $display("\nTest Case %0d: Data Out Cycle", test_num);

            reset = 1; #10 reset = 0;
            @(posedge clk);


            iobus_ios = 7'b1101100;
            iobus_iob_in = 36'hAAAAA_55555;

            @(posedge clk);
            iobus_datao_clear = 1;
            @(posedge clk);
            iobus_datao_clear = 0;
            iobus_datao_set = 1;
            @(posedge clk);
            iobus_datao_set = 0;



            #1;




            check_outputs(1'b0, 36'hAAAAA_55555, 7'h0, 1'b0);
        end
        endtask

    task testcase003;



        begin
            test_num = 3;
            $display("\nTest Case %0d: Control Out Cycle", test_num);

            reset = 1; #10 reset = 0;
            @(posedge clk);

            iobus_ios = 7'b1101100;
            iobus_iob_in = 36'h00000_00007;

            @(posedge clk);
            iobus_cono_clear = 1;
            @(posedge clk);
            iobus_cono_clear = 0;
            iobus_cono_set = 1;
            @(posedge clk);
            iobus_cono_set = 0;


            #1;



            check_outputs(1'b0, 36'h00000_00007, 7'b0000001, 1'b0);
        end
        endtask

    task testcase004;



        begin
            test_num = 4;
            $display("\nTest Case %0d: PI Request Stimulus", test_num);

            reset = 1; #10 reset = 0;


            ctl1 = 18'h3FFFF;
            ctl2 = 18'h00001;

            @(posedge clk);
            iobus_iob_fm_status = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 36'h0, 7'b1000000, 1'b0);
        end
        endtask

    task testcase005;



        begin
            test_num = 5;
            $display("\nTest Case %0d: RDI Pulse Interaction", test_num);

            reset = 1; #10 reset = 0;

            ctl3 = 18'h12345;
            ctl4 = 18'h6789A;
            iobus_rdi_pulse = 1;

            @(posedge clk);
            iobus_rdi_pulse = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 36'h12345_6789A, 7'h0, 1'b1);
        end
        endtask

    task testcase006;



        begin
            test_num = 6;
            $display("\nTest Case %0d: Bus Reset and Power-On", test_num);

            reset = 0;
            iobus_iob_poweron = 1;
            @(posedge clk);
            iobus_iob_reset = 1;
            repeat(5) @(posedge clk);
            iobus_iob_reset = 0;


            #1;



            check_outputs(1'b0, 36'h0, 7'h0, 1'b0);
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
        input expected_iobus_dr_split;
        input [35:0] expected_iobus_iob_out;
        input [6:0] expected_iobus_pi_req;
        input expected_iobus_rdi_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_iobus_dr_split === (expected_iobus_dr_split ^ iobus_dr_split ^ expected_iobus_dr_split) &&
                expected_iobus_iob_out === (expected_iobus_iob_out ^ iobus_iob_out ^ expected_iobus_iob_out) &&
                expected_iobus_pi_req === (expected_iobus_pi_req ^ iobus_pi_req ^ expected_iobus_pi_req) &&
                expected_iobus_rdi_data === (expected_iobus_rdi_data ^ iobus_rdi_data ^ expected_iobus_rdi_data)) begin
                $display("PASS");
                $display("  Outputs: iobus_dr_split=%b, iobus_iob_out=%h, iobus_pi_req=%h, iobus_rdi_data=%b",
                         iobus_dr_split, iobus_iob_out, iobus_pi_req, iobus_rdi_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iobus_dr_split=%b, iobus_iob_out=%h, iobus_pi_req=%h, iobus_rdi_data=%b",
                         expected_iobus_dr_split, expected_iobus_iob_out, expected_iobus_pi_req, expected_iobus_rdi_data);
                $display("  Got:      iobus_dr_split=%b, iobus_iob_out=%h, iobus_pi_req=%h, iobus_rdi_data=%b",
                         iobus_dr_split, iobus_iob_out, iobus_pi_req, iobus_rdi_data);
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

endmodule
