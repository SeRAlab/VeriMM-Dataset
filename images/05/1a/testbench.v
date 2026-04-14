`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
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
        .pop(pop),
        .push(push),
        .rst(rst),
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
            rst = 1;
            push = 0;
            pop = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Push/Pop Check");
            test_num = 2;
            reset_dut();


            push = 1; data_in = 8'hAA;
            @(posedge clk);
            push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            pop = 0;


            #1;



            check_outputs(8'hAA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running Testcase 003: Fill to Full Check");
            test_num = 3;
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                push = 1; data_in = i;
                @(posedge clk);
            end
            push = 0;
            #1;



            #1;




            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Data Ordering Check");
            test_num = 4;
            reset_dut();


            push = 1; data_in = 8'h11; @(posedge clk);
            push = 1; data_in = 8'h22; @(posedge clk);
            push = 1; data_in = 8'h33; @(posedge clk);
            push = 0;


            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;


            #1;



            check_outputs(8'h33, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Underflow Check");
            test_num = 5;
            reset_dut();


            pop = 1;
            @(posedge clk);
            pop = 0;
            @(posedge clk);


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Concurrent Push/Pop Check");
            test_num = 6;
            reset_dut();


            push = 1; data_in = 8'h55;
            @(posedge clk);


            push = 1; data_in = 8'h66;
            pop = 1;
            @(posedge clk);
            push = 0;
            pop = 0;
            @(posedge clk);




            pop = 1;
            @(posedge clk);
            pop = 0;

            #1;


            check_outputs(8'h66, 1'b1, 1'b0);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, empty, full);
    end

endmodule
