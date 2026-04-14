`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg reset;
    reg wr_en;
    wire [7:0] data_out;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .reset(reset),
        .wr_en(wr_en),
        .data_out(data_out),
        .empty(empty)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wr_en = 0;
            rd_en = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            data_in = 8'hAA;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            data_in = 8'h11;
            wr_en = 1;
            @(posedge clk);
            #1;

            data_in = 8'h22;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            wr_en = 1;
            data_in = 8'h01; @(posedge clk); #1;
            data_in = 8'h02; @(posedge clk); #1;
            data_in = 8'h03; @(posedge clk); #1;
            data_in = 8'h04; @(posedge clk); #1;
            wr_en = 0;


            rd_en = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            rd_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h04, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            data_in = 8'h55;
            wr_en = 1;
            @(posedge clk); #1;
            wr_en = 0;


            data_in = 8'h66;
            wr_en = 1;
            rd_en = 1;
            @(posedge clk); #1;
            wr_en = 0;
            rd_en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h66, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            wr_en = 1;
            data_in = 8'hFF;
            @(posedge clk); #1;
            data_in = 8'hEE;
            @(posedge clk); #1;
            wr_en = 0;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
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
        input [7:0] expected_data_out;
        input expected_empty;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b",
                         data_out, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b",
                         expected_data_out, expected_empty);
                $display("  Got:      data_out=%h, empty=%b",
                         data_out, empty);
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
        $dumpvars(0,clk, data_in, rd_en, reset, wr_en, data_out, empty);
    end

endmodule
