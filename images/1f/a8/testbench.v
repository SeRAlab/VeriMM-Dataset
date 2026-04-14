`timescale 1ns/1ps

module NVMe_FIFO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] cmd_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] cmd_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMe_FIFO dut (
        .clk(clk),
        .cmd_in(cmd_in),
        .pop(pop),
        .push(push),
        .rst(rst),
        .cmd_out(cmd_out),
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
            cmd_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Push and Pop");
            reset_dut();


            cmd_in = 8'hA5;
            push = 1;
            @(posedge clk);
            #1 push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Fill FIFO to Full");
            reset_dut();


            push = 1;
            cmd_in = 8'h11; @(posedge clk);
            cmd_in = 8'h22; @(posedge clk);
            cmd_in = 8'h33; @(posedge clk);
            cmd_in = 8'h44; @(posedge clk);
            #1 push = 0;
            @(posedge clk);



            #1;




            check_outputs(8'h11, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: FIFO Sequence Check");
            reset_dut();


            push = 1;
            cmd_in = 8'hAA; @(posedge clk);
            cmd_in = 8'hBB; @(posedge clk);
            #1 push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hBB, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Overflow Check");
            reset_dut();


            push = 1;
            cmd_in = 8'h01; @(posedge clk);
            cmd_in = 8'h02; @(posedge clk);
            cmd_in = 8'h03; @(posedge clk);
            cmd_in = 8'h04; @(posedge clk);

            cmd_in = 8'hFF; @(posedge clk);
            #1 push = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Underflow Check");
            reset_dut();


            pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMe_FIFO Testbench");
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
        input [7:0] expected_cmd_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_cmd_out === (expected_cmd_out ^ cmd_out ^ expected_cmd_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: cmd_out=%h, empty=%b, full=%b",
                         cmd_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_out=%h, empty=%b, full=%b",
                         expected_cmd_out, expected_empty, expected_full);
                $display("  Got:      cmd_out=%h, empty=%b, full=%b",
                         cmd_out, empty, full);
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
        $dumpvars(0,clk, cmd_in, pop, push, rst, cmd_out, empty, full);
    end

endmodule
