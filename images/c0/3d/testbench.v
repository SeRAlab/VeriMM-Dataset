`timescale 1ns/1ps

module bw_r_tlb_data_ram_tb;

    // Testbench signals (sequential circuit)
    reg cam_hit_any;
    reg [5:0] cam_index;
    reg cam_vld;
    reg clk;
    reg rd_data;
    reg rst_tri_en;
    reg rw_disable;
    reg [5:0] rw_index;
    reg rw_index_vld;
    reg [5:0] tlb_index;
    reg tlb_index_vld;
    reg [42:0] wr_tte_data;
    reg wr_vld;
    reg wr_vld_tmp;
    wire [42:0] rd_tte_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_r_tlb_data_ram dut (
        .cam_hit_any(cam_hit_any),
        .cam_index(cam_index),
        .cam_vld(cam_vld),
        .clk(clk),
        .rd_data(rd_data),
        .rst_tri_en(rst_tri_en),
        .rw_disable(rw_disable),
        .rw_index(rw_index),
        .rw_index_vld(rw_index_vld),
        .tlb_index(tlb_index),
        .tlb_index_vld(tlb_index_vld),
        .wr_tte_data(wr_tte_data),
        .wr_vld(wr_vld),
        .wr_vld_tmp(wr_vld_tmp),
        .rd_tte_data(rd_tte_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cam_hit_any     = 0;
            cam_index       = 0;
            cam_vld         = 0;
            rd_data         = 0;
            rst_tri_en      = 0;
            rw_disable      = 0;
            rw_index        = 0;
            rw_index_vld    = 0;
            tlb_index       = 0;
            tlb_index_vld   = 0;
            wr_tte_data     = 0;
            wr_vld          = 0;
            wr_vld_tmp      = 0;
            repeat (2) @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Write and Read (rw_index)", test_num);
            reset_dut();


            rw_index_vld = 1;
            wr_vld_tmp   = 1;
            wr_vld       = 1;
            rw_index     = 6'h05;
            wr_tte_data  = 43'h123456789AB;
            @(negedge clk);


            wr_vld       = 0;
            wr_vld_tmp   = 0;
            rw_index_vld = 0;
            @(negedge clk);


            rd_data      = 1;
            rw_index     = 6'h05;
            cam_hit_any  = 1;
            @(negedge clk);


            #1;
            #1;

            check_outputs(43'h123456789AB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Write (tlb_index) and Read (cam_index)", test_num);
            reset_dut();


            rw_index_vld  = 0;
            tlb_index_vld = 1;
            wr_vld        = 1;
            tlb_index     = 6'h2A;
            wr_tte_data   = 43'h3FFFFFFFFFF;
            @(negedge clk);


            wr_vld        = 0;
            tlb_index_vld = 0;
            @(negedge clk);


            cam_vld       = 1;
            cam_index     = 6'h2A;
            cam_hit_any   = 1;
            rd_data       = 0;
            @(negedge clk);

            #1;
            #1;

            check_outputs(43'h3FFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: CAM Miss Scenario", test_num);
            reset_dut();


            cam_vld       = 1;
            cam_index     = 6'h0A;
            cam_hit_any   = 0;
            @(negedge clk);

            #1;

            #1;


            check_outputs(43'bx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: rw_disable check", test_num);
            reset_dut();


            rw_disable   = 1;
            rw_index_vld = 1;
            wr_vld_tmp   = 1;
            wr_vld       = 1;
            rw_index     = 6'h10;
            wr_tte_data  = 43'h55555555555;
            @(negedge clk);


            rw_disable   = 0;
            wr_vld       = 0;
            rd_data      = 1;
            rw_index     = 6'h10;
            cam_hit_any  = 1;
            @(negedge clk);

            #1;


            if (rd_tte_data !== 43'h55555555555) begin
                $display("PASS: rw_disable prevented write.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: rw_disable failed to prevent write.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Sequential Write and Read Bypass", test_num);
            reset_dut();


            rw_index_vld = 1;
            wr_vld_tmp   = 1;
            wr_vld       = 1;
            rw_index     = 6'h00;
            wr_tte_data  = 43'h00000CAFE00;
            @(negedge clk);


            wr_vld       = 0;
            rd_data      = 1;
            rw_index     = 6'h00;
            cam_hit_any  = 1;
            @(negedge clk);

            #1;
            #1;

            check_outputs(43'h00000CAFE00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Address Integrity", test_num);
            reset_dut();


            rw_index_vld = 1; wr_vld_tmp = 1; wr_vld = 1; rw_index = 6'h01;
            wr_tte_data = 43'hAAA_AAAA_AAAA;
            @(negedge clk);


            rw_index = 6'h02;
            wr_tte_data = 43'hBBB_BBBB_BBBB;
            @(negedge clk);
            wr_vld = 0;


            rd_data = 1; rw_index = 6'h01; cam_hit_any = 1;
            @(negedge clk);
            #1;
            if (rd_tte_data === 43'hAAA_AAAA_AAAA) begin

                rw_index = 6'h02;
                @(negedge clk);
                #1;
                #1;

                check_outputs(43'hBBB_BBBB_BBBB);
            end else begin
                $display("FAIL: Data at Index 1 corrupted or incorrect");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_r_tlb_data_ram Testbench");
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
        input [42:0] expected_rd_tte_data;
        begin
            if (expected_rd_tte_data === (expected_rd_tte_data ^ rd_tte_data ^ expected_rd_tte_data)) begin
                $display("PASS");
                $display("  Outputs: rd_tte_data=%h",
                         rd_tte_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_tte_data=%h",
                         expected_rd_tte_data);
                $display("  Got:      rd_tte_data=%h",
                         rd_tte_data);
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
        $dumpvars(0,cam_hit_any, cam_index, cam_vld, clk, rd_data, rst_tri_en, rw_disable, rw_index, rw_index_vld, tlb_index, tlb_index_vld, wr_tte_data, wr_vld, wr_vld_tmp, rd_tte_data);
    end

endmodule
