`timescale 1ns/1ps

module llmanager_refcount_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] drq_end_page;
    reg drq_srdy;
    reg [7:0] drq_start_page;
    reg reclaim_drdy;
    reg [2:0] ref_rd_data;
    reg [2:0] refup_count;
    reg [7:0] refup_page;
    reg refup_srdy;
    reg reset;
    wire drq_drdy;
    wire [7:0] reclaim_end_page;
    wire reclaim_srdy;
    wire [7:0] reclaim_start_page;
    wire [7:0] ref_rd_addr;
    wire ref_rd_en;
    wire [7:0] ref_wr_addr;
    wire [2:0] ref_wr_data;
    wire ref_wr_en;
    wire refup_drdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    llmanager_refcount dut (
        .clk(clk),
        .drq_end_page(drq_end_page),
        .drq_srdy(drq_srdy),
        .drq_start_page(drq_start_page),
        .reclaim_drdy(reclaim_drdy),
        .ref_rd_data(ref_rd_data),
        .refup_count(refup_count),
        .refup_page(refup_page),
        .refup_srdy(refup_srdy),
        .reset(reset),
        .drq_drdy(drq_drdy),
        .reclaim_end_page(reclaim_end_page),
        .reclaim_srdy(reclaim_srdy),
        .reclaim_start_page(reclaim_start_page),
        .ref_rd_addr(ref_rd_addr),
        .ref_rd_en(ref_rd_en),
        .ref_wr_addr(ref_wr_addr),
        .ref_wr_data(ref_wr_data),
        .ref_wr_en(ref_wr_en),
        .refup_drdy(refup_drdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            drq_srdy = 0;
            drq_start_page = 8'h0;
            drq_end_page = 8'h0;
            reclaim_drdy = 0;
            refup_srdy = 0;
            refup_page = 8'h0;
            refup_count = 3'h0;
            ref_rd_data = 3'h0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reference Update Request", test_num);


            @(posedge clk);
            refup_srdy = 1;
            refup_page = 8'hA5;
            refup_count = 3'd4;


            wait(refup_drdy == 1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 8'h00, 1'b0, 8'h00, 8'h00, 1'b0, 8'hA5, 3'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: DRQ leading to Reclaim (Count 1 -> 0)", test_num);


            @(posedge clk);
            drq_srdy = 1;
            drq_start_page = 8'h10;
            drq_end_page = 8'h10;
            reclaim_drdy = 1;


            wait(ref_rd_en == 1 && ref_rd_addr == 8'h10);
            @(posedge clk);
            ref_rd_data = 3'd1;


            wait(reclaim_srdy == 1);
            #1;


            #1;



            check_outputs(1'b0, 8'h10, 1'b1, 8'h10, 8'h10, 1'b0, 8'h10, 3'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: DRQ Decrement (Count 5 -> 4)", test_num);


            @(posedge clk);
            drq_srdy = 1;
            drq_start_page = 8'h22;
            drq_end_page = 8'h22;


            wait(ref_rd_en == 1 && ref_rd_addr == 8'h22);
            @(posedge clk);
            ref_rd_data = 3'd5;


            wait(ref_wr_en == 1);
            #1;


            #1;



            check_outputs(1'b0, 8'h00, 1'b0, 8'h00, 8'h22, 1'b0, 8'h22, 3'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Range Request Processing (Start 0x40, End 0x41)", test_num);


            @(posedge clk);
            drq_srdy = 1;
            drq_start_page = 8'h40;
            drq_end_page = 8'h41;
            reclaim_drdy = 1;


            wait(ref_rd_en == 1 && ref_rd_addr == 8'h40);
            @(posedge clk);
            ref_rd_data = 3'd1;
            wait(reclaim_srdy == 1 && reclaim_start_page == 8'h40);


            @(posedge clk);


            wait(ref_rd_en == 1 && ref_rd_addr == 8'h41);
            @(posedge clk);
            ref_rd_data = 3'd1;
            wait(reclaim_srdy == 1 && reclaim_start_page == 8'h41);
            #1;


            #1;



            check_outputs(1'b0, 8'h41, 1'b1, 8'h41, 8'h41, 1'b0, 8'h41, 3'd0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("llmanager_refcount Testbench");
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
        input expected_drq_drdy;
        input [7:0] expected_reclaim_end_page;
        input expected_reclaim_srdy;
        input [7:0] expected_reclaim_start_page;
        input [7:0] expected_ref_rd_addr;
        input expected_ref_rd_en;
        input [7:0] expected_ref_wr_addr;
        input [2:0] expected_ref_wr_data;
        input expected_ref_wr_en;
        input expected_refup_drdy;
        begin
            if (expected_drq_drdy === (expected_drq_drdy ^ drq_drdy ^ expected_drq_drdy) &&
                expected_reclaim_end_page === (expected_reclaim_end_page ^ reclaim_end_page ^ expected_reclaim_end_page) &&
                expected_reclaim_srdy === (expected_reclaim_srdy ^ reclaim_srdy ^ expected_reclaim_srdy) &&
                expected_reclaim_start_page === (expected_reclaim_start_page ^ reclaim_start_page ^ expected_reclaim_start_page) &&
                expected_ref_rd_addr === (expected_ref_rd_addr ^ ref_rd_addr ^ expected_ref_rd_addr) &&
                expected_ref_rd_en === (expected_ref_rd_en ^ ref_rd_en ^ expected_ref_rd_en) &&
                expected_ref_wr_addr === (expected_ref_wr_addr ^ ref_wr_addr ^ expected_ref_wr_addr) &&
                expected_ref_wr_data === (expected_ref_wr_data ^ ref_wr_data ^ expected_ref_wr_data) &&
                expected_ref_wr_en === (expected_ref_wr_en ^ ref_wr_en ^ expected_ref_wr_en) &&
                expected_refup_drdy === (expected_refup_drdy ^ refup_drdy ^ expected_refup_drdy)) begin
                $display("PASS");
                $display("  Outputs: drq_drdy=%b, reclaim_end_page=%h, reclaim_srdy=%b, reclaim_start_page=%h, ref_rd_addr=%h, ref_rd_en=%b, ref_wr_addr=%h, ref_wr_data=%h, ref_wr_en=%b, refup_drdy=%b",
                         drq_drdy, reclaim_end_page, reclaim_srdy, reclaim_start_page, ref_rd_addr, ref_rd_en, ref_wr_addr, ref_wr_data, ref_wr_en, refup_drdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: drq_drdy=%b, reclaim_end_page=%h, reclaim_srdy=%b, reclaim_start_page=%h, ref_rd_addr=%h, ref_rd_en=%b, ref_wr_addr=%h, ref_wr_data=%h, ref_wr_en=%b, refup_drdy=%b",
                         expected_drq_drdy, expected_reclaim_end_page, expected_reclaim_srdy, expected_reclaim_start_page, expected_ref_rd_addr, expected_ref_rd_en, expected_ref_wr_addr, expected_ref_wr_data, expected_ref_wr_en, expected_refup_drdy);
                $display("  Got:      drq_drdy=%b, reclaim_end_page=%h, reclaim_srdy=%b, reclaim_start_page=%h, ref_rd_addr=%h, ref_rd_en=%b, ref_wr_addr=%h, ref_wr_data=%h, ref_wr_en=%b, refup_drdy=%b",
                         drq_drdy, reclaim_end_page, reclaim_srdy, reclaim_start_page, ref_rd_addr, ref_rd_en, ref_wr_addr, ref_wr_data, ref_wr_en, refup_drdy);
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
        $dumpvars(0,clk, drq_end_page, drq_srdy, drq_start_page, reclaim_drdy, ref_rd_data, refup_count, refup_page, refup_srdy, reset, drq_drdy, reclaim_end_page, reclaim_srdy, reclaim_start_page, ref_rd_addr, ref_rd_en, ref_wr_addr, ref_wr_data, ref_wr_en, refup_drdy);
    end

endmodule
