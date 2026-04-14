`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg reset;
    reg sel_async;
    reg sel_chain;
    reg sel_dir_async;
    reg sel_dir_gen;
    reg sel_dir_pg;
    reg sel_dir_single;
    reg sel_dir_sync;
    reg sel_gen;
    reg sel_pg;
    reg sel_single;
    reg sel_sync;
    reg sel_sync_out;
    reg [4:0] src_async;
    reg [3:0] src_async_pos;
    reg [4:0] src_gen;
    reg [4:0] src_pg;
    reg [4:0] src_single;
    reg [4:0] src_sync;
    reg src_sync_direct;
    reg sync;
    wire [4:0] dst_dir;
    wire [4:0] dst_sync;
    wire dst_sync_direct;
    wire [4:0] dst_tbm;
    wire [3:0] dst_tbm_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .sel_async(sel_async),
        .sel_chain(sel_chain),
        .sel_dir_async(sel_dir_async),
        .sel_dir_gen(sel_dir_gen),
        .sel_dir_pg(sel_dir_pg),
        .sel_dir_single(sel_dir_single),
        .sel_dir_sync(sel_dir_sync),
        .sel_gen(sel_gen),
        .sel_pg(sel_pg),
        .sel_single(sel_single),
        .sel_sync(sel_sync),
        .sel_sync_out(sel_sync_out),
        .src_async(src_async),
        .src_async_pos(src_async_pos),
        .src_gen(src_gen),
        .src_pg(src_pg),
        .src_single(src_single),
        .src_sync(src_sync),
        .src_sync_direct(src_sync_direct),
        .sync(sync),
        .dst_dir(dst_dir),
        .dst_sync(dst_sync),
        .dst_sync_direct(dst_sync_direct),
        .dst_tbm(dst_tbm),
        .dst_tbm_pos(dst_tbm_pos)
    );
    task perform_reset;

    begin
        reset = 1;
        clk = 0;
        #10;
        clk = 1;
        #10;
        reset = 0;
        clk = 0;
        #10;
    end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and All Selectors Zero", test_num);
            perform_reset();


            sel_async = 0; sel_sync = 0; sel_single = 0; sel_gen = 0; sel_pg = 0;
            sel_dir_async = 0; sel_dir_sync = 0; sel_dir_single = 0; sel_dir_gen = 0; sel_dir_pg = 0;
            sel_chain = 0; sel_sync_out = 0;

            src_async = 5'h1F; src_async_pos = 4'hF;
            src_sync = 5'h1F; src_sync_direct = 1'b1;
            src_single = 5'h1F; src_gen = 5'h1F; src_pg = 5'h1F;


            #1;



            check_outputs(5'h00, 5'h00, 1'b0, 5'h00, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Async Source to TBM and Position", test_num);
            perform_reset();

            sel_async = 1;
            src_async = 5'h12;
            src_async_pos = 4'hA;


            #1;



            check_outputs(5'h00, 5'h00, 1'b0, 5'h12, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sync Source and Direct Sync", test_num);
            perform_reset();

            sel_sync = 1;
            src_sync = 5'h0D;
            src_sync_direct = 1'b1;


            #1;



            check_outputs(5'h00, 5'h00, 1'b1, 5'h0D, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Direct Output Path (Gen and PG)", test_num);
            perform_reset();

            sel_dir_gen = 1;
            sel_dir_pg = 1;
            src_gen = 5'h05;
            src_pg = 5'h0A;


            #1;



            check_outputs(5'h0F, 5'h00, 1'b0, 5'h00, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Sources ORed into TBM", test_num);
            perform_reset();

            sel_single = 1;
            sel_gen = 1;
            src_single = 5'h10;
            src_gen = 5'h01;

            #1;


            check_outputs(5'h00, 5'h00, 1'b0, 5'h11, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sync Out Destination Control", test_num);
            perform_reset();

            sel_async = 1;
            sel_sync_out = 1;
            src_async = 5'h15;


            #1;



            check_outputs(5'h00, 5'h15, 1'b0, 5'h15, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Mix and Chaining", test_num);
            perform_reset();

            sel_async = 1;
            sel_dir_sync = 1;
            sel_sync_out = 1;

            src_async = 5'h03;
            src_sync = 5'h1C;




            #1;





            check_outputs(5'h1C, 5'h03, 1'b0, 5'h03, 4'h0);
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
        input [4:0] expected_dst_dir;
        input [4:0] expected_dst_sync;
        input expected_dst_sync_direct;
        input [4:0] expected_dst_tbm;
        input [3:0] expected_dst_tbm_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dst_dir === (expected_dst_dir ^ dst_dir ^ expected_dst_dir) &&
                expected_dst_sync === (expected_dst_sync ^ dst_sync ^ expected_dst_sync) &&
                expected_dst_sync_direct === (expected_dst_sync_direct ^ dst_sync_direct ^ expected_dst_sync_direct) &&
                expected_dst_tbm === (expected_dst_tbm ^ dst_tbm ^ expected_dst_tbm) &&
                expected_dst_tbm_pos === (expected_dst_tbm_pos ^ dst_tbm_pos ^ expected_dst_tbm_pos)) begin
                $display("PASS");
                $display("  Outputs: dst_dir=%h, dst_sync=%h, dst_sync_direct=%b, dst_tbm=%h, dst_tbm_pos=%h",
                         dst_dir, dst_sync, dst_sync_direct, dst_tbm, dst_tbm_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst_dir=%h, dst_sync=%h, dst_sync_direct=%b, dst_tbm=%h, dst_tbm_pos=%h",
                         expected_dst_dir, expected_dst_sync, expected_dst_sync_direct, expected_dst_tbm, expected_dst_tbm_pos);
                $display("  Got:      dst_dir=%h, dst_sync=%h, dst_sync_direct=%b, dst_tbm=%h, dst_tbm_pos=%h",
                         dst_dir, dst_sync, dst_sync_direct, dst_tbm, dst_tbm_pos);
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
