`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset;
    reg [7:0] w_data;
    reg wr;
    wire empty;
    wire full;
    wire [7:0] r_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd(rd),
        .reset(reset),
        .w_data(w_data),
        .wr(wr),
        .empty(empty),
        .full(full),
        .r_data(r_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rd = 0;
            wr = 0;
            w_data = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, r_data);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write", test_num);
            reset_dut();

            wr = 1;
            w_data = 8'hA5;
            @(posedge clk);
            wr = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, r_data);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write and Read back", test_num);
            reset_dut();


            wr = 1;
            w_data = 8'h55;
            @(posedge clk);
            wr = 0;
            @(posedge clk);


            rd = 1;
            @(posedge clk);
            rd = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 8'h55);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill FIFO until Full", test_num);
            reset_dut();


            i = 0;
            while (full === 0 && i < 256) begin
                wr = 1;
                w_data = i[7:0];
                @(posedge clk);
                i = i + 1;
            end
            wr = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, r_data);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify FIFO Ordering", test_num);
            reset_dut();


            wr = 1; w_data = 8'h11; @(posedge clk);
            wr = 1; w_data = 8'h22; @(posedge clk);
            wr = 1; w_data = 8'h33; @(posedge clk);
            wr = 0;
            @(posedge clk);


            rd = 1;
            @(posedge clk);
            rd = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'h11);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] last_val;
        begin
            test_num = 6;
            $display("Testcase %0d: Fill and Drain", test_num);
            reset_dut();


            i = 0;
            while (full === 0 && i < 256) begin
                wr = 1; w_data = 8'hD0 + i[7:0];
                @(posedge clk);
                i = i + 1;
            end
            wr = 0;
            @(posedge clk);


            while (empty === 0) begin
                last_val = r_data;
                rd = 1;
                @(posedge clk);
            end
            rd = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, r_data);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            wr = 1; w_data = 8'hAA; @(posedge clk);
            wr = 0; @(posedge clk);


            wr = 1; w_data = 8'hBB;
            rd = 1;
            @(posedge clk);
            wr = 0;
            rd = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'hAA);
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_r_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_r_data === (expected_r_data ^ r_data ^ expected_r_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, r_data=%h",
                         empty, full, r_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, r_data=%h",
                         expected_empty, expected_full, expected_r_data);
                $display("  Got:      empty=%b, full=%b, r_data=%h",
                         empty, full, r_data);
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
        $dumpvars(0,clk, rd, reset, w_data, wr, empty, full, r_data);
    end

endmodule
