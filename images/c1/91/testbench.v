`timescale 1ns/1ps

module ddr_infrastructure_tb;

    // Testbench signals (sequential circuit)
    reg clk_int;
    reg [4:0] delay_sel_val;
    reg rst_calib1;
    wire [4:0] dbg_delay_sel;
    wire dbg_rst_calib;
    wire [4:0] delay_sel_val1_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ddr_infrastructure dut (
        .clk_int(clk_int),
        .delay_sel_val(delay_sel_val),
        .rst_calib1(rst_calib1),
        .dbg_delay_sel(dbg_delay_sel),
        .dbg_rst_calib(dbg_rst_calib),
        .delay_sel_val1_val(delay_sel_val1_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk_int = 0;
        forever #5 clk_int = ~clk_int;
    end

        task reset_dut;

        begin
            $display("  Resetting DUT...");
            rst_calib1 = 1'b1;
            delay_sel_val = 5'b00000;
            repeat (10) @(posedge clk_int);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(5'h00, 1'b1, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Release Reset and Set Mid-range Delay", test_num);
            reset_dut();


            rst_calib1 = 1'b0;
            delay_sel_val = 5'h0A;


            repeat (10) @(posedge clk_int);
            #1;

            #1;


            check_outputs(5'h0A, 1'b0, 5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Maximum Delay Value (5'h1F)", test_num);
            reset_dut();

            rst_calib1 = 1'b0;
            delay_sel_val = 5'h1F;

            repeat (10) @(posedge clk_int);
            #1;

            #1;


            check_outputs(5'h1F, 1'b0, 5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Reset Synchronization Recovery", test_num);
            reset_dut();


            delay_sel_val = 5'h15;
            rst_calib1 = 1'b0;
            repeat (5) @(posedge clk_int);


            rst_calib1 = 1'b1;
            repeat (10) @(posedge clk_int);
            #1;


            #1;



            check_outputs(5'h15, 1'b1, 5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rapid Delay Change Stability", test_num);
            reset_dut();

            rst_calib1 = 1'b0;
            delay_sel_val = 5'h01;
            @(posedge clk_int);
            delay_sel_val = 5'h02;
            @(posedge clk_int);
            delay_sel_val = 5'h04;
            @(posedge clk_int);
            delay_sel_val = 5'h08;

            repeat (10) @(posedge clk_int);
            #1;


            #1;



            check_outputs(5'h08, 1'b0, 5'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ddr_infrastructure Testbench");
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
        input [4:0] expected_dbg_delay_sel;
        input expected_dbg_rst_calib;
        input [4:0] expected_delay_sel_val1_val;
        begin
            if (expected_dbg_delay_sel === (expected_dbg_delay_sel ^ dbg_delay_sel ^ expected_dbg_delay_sel) &&
                expected_dbg_rst_calib === (expected_dbg_rst_calib ^ dbg_rst_calib ^ expected_dbg_rst_calib) &&
                expected_delay_sel_val1_val === (expected_delay_sel_val1_val ^ delay_sel_val1_val ^ expected_delay_sel_val1_val)) begin
                $display("PASS");
                $display("  Outputs: dbg_delay_sel=%h, dbg_rst_calib=%b, delay_sel_val1_val=%h",
                         dbg_delay_sel, dbg_rst_calib, delay_sel_val1_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dbg_delay_sel=%h, dbg_rst_calib=%b, delay_sel_val1_val=%h",
                         expected_dbg_delay_sel, expected_dbg_rst_calib, expected_delay_sel_val1_val);
                $display("  Got:      dbg_delay_sel=%h, dbg_rst_calib=%b, delay_sel_val1_val=%h",
                         dbg_delay_sel, dbg_rst_calib, delay_sel_val1_val);
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
        $dumpvars(0,clk_int, delay_sel_val, rst_calib1, dbg_delay_sel, dbg_rst_calib, delay_sel_val1_val);
    end

endmodule
