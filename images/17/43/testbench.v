`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [3:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
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
            wr_en = 0;
            rd_en = 0;
            data_in = 0;


            #20;
        end
        endtask
    task write_fifo;

        input [3:0] val;
        begin
            @(posedge clk);
            #1;
            wr_en = 1;
            data_in = val;
            @(posedge clk);
            #1;
            wr_en = 0;
        end
        endtask

    task read_fifo;

        begin
            @(posedge clk);
            #1;
            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'bxxxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write/Read", test_num);
            reset_dut();
            write_fifo(4'hA);
            read_fifo();


            #1;



            check_outputs(4'hA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO to Capacity", test_num);
            reset_dut();
            write_fifo(4'h1);
            write_fifo(4'h2);
            write_fifo(4'h3);
            write_fifo(4'h4);

            #1;


            check_outputs(4'bxxxx, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Fill and Empty Sequence", test_num);
            reset_dut();
            write_fifo(4'h5);
            write_fifo(4'h6);
            write_fifo(4'h7);
            write_fifo(4'h8);
            read_fifo();
            read_fifo();
            read_fifo();
            read_fifo();

            #1;


            check_outputs(4'h8, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overflow Check", test_num);
            reset_dut();
            write_fifo(4'h1);
            write_fifo(4'h2);
            write_fifo(4'h3);
            write_fifo(4'h4);
            write_fifo(4'hF);

            #1;


            check_outputs(4'bxxxx, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Underflow Check", test_num);
            reset_dut();
            read_fifo();

            #1;


            check_outputs(4'bxxxx, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();
            write_fifo(4'hE);
            @(posedge clk);
            #1;
            wr_en = 1;
            rd_en = 1;
            data_in = 4'h9;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;

            #1;


            check_outputs(4'hE, 1'b0, 1'b0);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rd_en, wr_en, data_out, empty, full);
    end

endmodule
