`timescale 1ns/1ps

module fifo_sync_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg rst_n;
    reg wr_en;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_sync dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            wr_en = 0;
            rd_en = 0;
            data_in = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Power-on Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Write then Read", test_num);
            reset_dut();


            wr_en = 1; data_in = 8'hA5;
            @(posedge clk);
            wr_en = 0;
            #1;


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Fill to Full (Depth 4)", test_num);
            reset_dut();

            wr_en = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            wr_en = 0;
            #1;


            #1;



            check_outputs(8'h11, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Fill then Empty", test_num);
            reset_dut();


            wr_en = 1;
            data_in = 8'h10; @(posedge clk);
            data_in = 8'h20; @(posedge clk);
            data_in = 8'h30; @(posedge clk);
            data_in = 8'h40; @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(8'h40, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Overflow Test", test_num);
            reset_dut();

            wr_en = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            wr_en = 0;
            #1;


            #1;



            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Underflow Test", test_num);
            reset_dut();

            rd_en = 1;
            repeat(2) @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            wr_en = 1; data_in = 8'hAA;
            @(posedge clk);


            wr_en = 1; data_in = 8'hBB;
            rd_en = 1;
            @(posedge clk);
            wr_en = 0; rd_en = 0;
            #1;



            #1;




            check_outputs(8'hBB, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %03d: Simultaneous R/W at Full", test_num);
            reset_dut();


            wr_en = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);



            wr_en = 1; rd_en = 1; data_in = 8'h05;
            @(posedge clk);
            wr_en = 0; rd_en = 0;
            #1;


            #1;



            check_outputs(8'h02, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_sync Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, rd_en, rst_n, wr_en, data_out, empty, full);
    end

endmodule
