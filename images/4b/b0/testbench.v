`timescale 1ns/1ps

module fifo_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg rst_n;
    reg write_en;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_en(write_en),
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
            write_en = 0;
            read_en = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write and Read", test_num);
            reset_dut();


            write_en = 1;
            data_in = 8'hA5;
            @(posedge clk);
            write_en = 0;


            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1, 1'b0);
            read_en = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Fill to Full", test_num);
            reset_dut();

            write_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            write_en = 0;
            #1;
            #1;

            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Read until Empty", test_num);
            reset_dut();


            write_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i + 10;
                @(posedge clk);
            end
            write_en = 0;


            read_en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h19, 1'b1, 1'b0);
            read_en = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overflow Test", test_num);
            reset_dut();

            write_en = 1;

            for (i = 0; i < 17; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            write_en = 0;
            #1;

            #1;


            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Underflow Test", test_num);
            reset_dut();

            read_en = 1;
            @(posedge clk);
            read_en = 0;
            #1;

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Wrap-around Logic", test_num);
            reset_dut();


            write_en = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = i; @(posedge clk);
            end
            write_en = 0;


            read_en = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            read_en = 0;


            write_en = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = 8'hFF; @(posedge clk);
            end
            write_en = 0;
            #1;

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Simultaneous R/W", test_num);
            reset_dut();


            write_en = 1; data_in = 8'h11; @(posedge clk);


            read_en = 1; data_in = 8'h22; @(posedge clk);
            read_en = 0; write_en = 0;
            #1;

            #1;


            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_8bit Testbench");
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
        $dumpvars(0,clk, data_in, read_en, rst_n, write_en, data_out, empty, full);
    end

endmodule
