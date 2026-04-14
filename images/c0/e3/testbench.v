`timescale 1ns/1ps

module ddr_cal_ctl_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] flop2;
    reg reset;
    wire [5:0] dbg_cnt;
    wire dbg_enb_trans_two_dtct;
    wire [4:0] dbg_phase_cnt;
    wire dbg_trans_onedtct;
    wire dbg_trans_twodtct;
    wire [4:0] tapfordqs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ddr_cal_ctl dut (
        .clk(clk),
        .flop2(flop2),
        .reset(reset),
        .dbg_cnt(dbg_cnt),
        .dbg_enb_trans_two_dtct(dbg_enb_trans_two_dtct),
        .dbg_phase_cnt(dbg_phase_cnt),
        .dbg_trans_onedtct(dbg_trans_onedtct),
        .dbg_trans_twodtct(dbg_trans_twodtct),
        .tapfordqs(tapfordqs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            flop2 = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(6'h00, 1'b0, 5'h00, 1'b0, 1'b0, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            flop2 = 32'h0000_0000;

            repeat(40) @(posedge clk);

            #1;


            check_outputs(6'h20, 1'b0, 5'h00, 1'b0, 1'b0, 5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            flop2 = 32'hFFFF_0000;
            repeat(40) @(posedge clk);



            #1;




            check_outputs(6'h20, 1'b0, 5'h10, 1'b1, 1'b0, 5'h18);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            flop2 = 32'h00FF_FF00;
            repeat(40) @(posedge clk);



            #1;




            check_outputs(6'h20, 1'b1, 5'h10, 1'b1, 1'b1, 5'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            flop2 = 32'h0000_7C00;
            repeat(40) @(posedge clk);


            #1;



            check_outputs(6'h20, 1'b1, 5'h05, 1'b1, 1'b1, 5'h0C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ddr_cal_ctl Testbench");
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
        input [5:0] expected_dbg_cnt;
        input expected_dbg_enb_trans_two_dtct;
        input [4:0] expected_dbg_phase_cnt;
        input expected_dbg_trans_onedtct;
        input expected_dbg_trans_twodtct;
        input [4:0] expected_tapfordqs;
        begin
            if (expected_dbg_cnt === (expected_dbg_cnt ^ dbg_cnt ^ expected_dbg_cnt) &&
                expected_dbg_enb_trans_two_dtct === (expected_dbg_enb_trans_two_dtct ^ dbg_enb_trans_two_dtct ^ expected_dbg_enb_trans_two_dtct) &&
                expected_dbg_phase_cnt === (expected_dbg_phase_cnt ^ dbg_phase_cnt ^ expected_dbg_phase_cnt) &&
                expected_dbg_trans_onedtct === (expected_dbg_trans_onedtct ^ dbg_trans_onedtct ^ expected_dbg_trans_onedtct) &&
                expected_dbg_trans_twodtct === (expected_dbg_trans_twodtct ^ dbg_trans_twodtct ^ expected_dbg_trans_twodtct) &&
                expected_tapfordqs === (expected_tapfordqs ^ tapfordqs ^ expected_tapfordqs)) begin
                $display("PASS");
                $display("  Outputs: dbg_cnt=%h, dbg_enb_trans_two_dtct=%b, dbg_phase_cnt=%h, dbg_trans_onedtct=%b, dbg_trans_twodtct=%b, tapfordqs=%h",
                         dbg_cnt, dbg_enb_trans_two_dtct, dbg_phase_cnt, dbg_trans_onedtct, dbg_trans_twodtct, tapfordqs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dbg_cnt=%h, dbg_enb_trans_two_dtct=%b, dbg_phase_cnt=%h, dbg_trans_onedtct=%b, dbg_trans_twodtct=%b, tapfordqs=%h",
                         expected_dbg_cnt, expected_dbg_enb_trans_two_dtct, expected_dbg_phase_cnt, expected_dbg_trans_onedtct, expected_dbg_trans_twodtct, expected_tapfordqs);
                $display("  Got:      dbg_cnt=%h, dbg_enb_trans_two_dtct=%b, dbg_phase_cnt=%h, dbg_trans_onedtct=%b, dbg_trans_twodtct=%b, tapfordqs=%h",
                         dbg_cnt, dbg_enb_trans_two_dtct, dbg_phase_cnt, dbg_trans_onedtct, dbg_trans_twodtct, tapfordqs);
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
        $dumpvars(0,clk, flop2, reset, dbg_cnt, dbg_enb_trans_two_dtct, dbg_phase_cnt, dbg_trans_onedtct, dbg_trans_twodtct, tapfordqs);
    end

endmodule
