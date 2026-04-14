`timescale 1ns/1ps

module fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rd_en;
    reg reset;
    reg wr_en;
    wire [3:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .reset(reset),
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
            reset = 1;
            wr_en = 0;
            rd_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            reset_dut();
            #1;
            #1;

            check_outputs(4'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write/Read");
            reset_dut();

            wr_en = 1; data_in = 4'hA; @(posedge clk);
            wr_en = 0; @(posedge clk);

            rd_en = 1; @(posedge clk);
            rd_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Fill to Full");
            reset_dut();
            wr_en = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            wr_en = 0;
            #1;
            #1;

            check_outputs(4'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Fill and Drain");
            reset_dut();

            wr_en = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow Test");
            reset_dut();
            wr_en = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            wr_en = 0;

            rd_en = 1; @(posedge clk);
            rd_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Underflow Test");
            reset_dut();
            rd_en = 1; @(posedge clk);
            rd_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Circular Pointers Test");
            reset_dut();

            wr_en = 1; data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            wr_en = 0;

            rd_en = 1; @(posedge clk); @(posedge clk);
            rd_en = 0;

            wr_en = 1; data_in = 4'hA; @(posedge clk);
            data_in = 4'hB; @(posedge clk);
            data_in = 4'hC; @(posedge clk);
            wr_en = 0;

            rd_en = 1; @(posedge clk);
            rd_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Simultaneous Read and Write");
            reset_dut();

            wr_en = 1; data_in = 4'h5; @(posedge clk);

            wr_en = 1; data_in = 4'h6; rd_en = 1; @(posedge clk);
            wr_en = 0; rd_en = 0; @(posedge clk);

            rd_en = 1; @(posedge clk);
            rd_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo Testbench");
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
        $dumpvars(0,clk, data_in, rd_en, reset, wr_en, data_out, empty, full);
    end

endmodule
