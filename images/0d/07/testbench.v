`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read;
    reg reset;
    reg write;
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
        .read(read),
        .reset(reset),
        .write(write),
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
            data_in = 8'h0;
            write = 0;
            read = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write/Read", test_num);
            reset_dut();


            data_in = 8'hAA;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;


            read = 1;
            @(posedge clk);
            #1;
            read = 0;


            #1;



            check_outputs(8'hAA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill to Full", test_num);
            reset_dut();


            data_in = 8'h11; write = 1; @(posedge clk); #1;
            data_in = 8'h22; write = 1; @(posedge clk); #1;
            data_in = 8'h33; write = 1; @(posedge clk); #1;
            data_in = 8'h44; write = 1; @(posedge clk); #1;
            write = 0;


            #1;



            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full to Empty", test_num);
            reset_dut();


            data_in = 8'h10; write = 1; @(posedge clk); #1;
            data_in = 8'h20; write = 1; @(posedge clk); #1;
            data_in = 8'h30; write = 1; @(posedge clk); #1;
            data_in = 8'h40; write = 1; @(posedge clk); #1;
            write = 0;


            read = 1; @(posedge clk); #1;
            read = 1; @(posedge clk); #1;
            read = 1; @(posedge clk); #1;
            read = 1; @(posedge clk); #1;
            read = 0;


            #1;



            check_outputs(8'h40, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around logic", test_num);
            reset_dut();


            data_in = 8'hA1; write = 1; @(posedge clk); #1;
            data_in = 8'hA2; write = 1; @(posedge clk); #1;
            write = 0;


            read = 1; @(posedge clk); #1;
            read = 1; @(posedge clk); #1;
            read = 0;


            data_in = 8'hB1; write = 1; @(posedge clk); #1;
            data_in = 8'hB2; write = 1; @(posedge clk); #1;
            data_in = 8'hB3; write = 1; @(posedge clk); #1;
            write = 0;


            read = 1; @(posedge clk); #1;
            read = 0;


            #1;



            check_outputs(8'hB1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Protection", test_num);
            reset_dut();


            data_in = 8'h01; write = 1; @(posedge clk); #1;
            data_in = 8'h02; write = 1; @(posedge clk); #1;
            data_in = 8'h03; write = 1; @(posedge clk); #1;
            data_in = 8'h04; write = 1; @(posedge clk); #1;
            data_in = 8'h05; write = 1; @(posedge clk); #1;
            write = 0;


            #1;



            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Protection", test_num);
            reset_dut();


            read = 1; @(posedge clk); #1;
            read = 0;


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
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
        $dumpvars(0,clk, data_in, read, reset, write, data_out, empty, full);
    end

endmodule
