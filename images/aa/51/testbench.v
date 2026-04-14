`timescale 1ns/1ps

module FIFO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_en;
    reg rst_n;
    reg [7:0] write_data;
    reg write_en;
    wire empty;
    wire full;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FIFO dut (
        .clk(clk),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_data(write_data),
        .write_en(write_en),
        .empty(empty),
        .full(full),
        .read_data(read_data)
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
            write_data = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State Check");
            reset_dut();


            #1;



            check_outputs(1'b1, 1'b0, read_data);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Read");
            reset_dut();


            write_en = 1;
            write_data = 8'hA5;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;


            #1;



            check_outputs(1'b1, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill FIFO to Full");
            reset_dut();

            write_en = 1;
            for (i = 1; i <= 15; i = i + 1) begin
                write_data = i;
                @(posedge clk);
            end
            #1 write_en = 0;



            #1;




            check_outputs(1'b0, 1'b1, 8'h01);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill and then Empty");
            reset_dut();


            write_en = 1;
            for (i = 1; i <= 15; i = i + 1) begin
                write_data = i;
                @(posedge clk);
            end
            #1 write_en = 0;


            read_en = 1;
            for (i = 1; i <= 15; i = i + 1) begin
                @(posedge clk);
            end
            #1 read_en = 0;


            #1;



            check_outputs(1'b1, 1'b0, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous Read and Write");
            reset_dut();


            write_en = 1;
            write_data = 8'h11;
            @(posedge clk);


            write_data = 8'h22;
            read_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;
            read_en = 0;



            #1;




            check_outputs(1'b0, 1'b0, 8'h22);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Overflow Prevention");
            reset_dut();


            write_en = 1;
            for (i = 1; i <= 15; i = i + 1) begin
                write_data = i;
                @(posedge clk);
            end


            write_data = 8'hFF;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            for (i = 1; i <= 15; i = i + 1) begin
                @(posedge clk);
            end
            #1 read_en = 0;


            #1;



            check_outputs(1'b1, 1'b0, 8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FIFO Testbench");
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_read_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, read_data=%h",
                         empty, full, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, read_data=%h",
                         expected_empty, expected_full, expected_read_data);
                $display("  Got:      empty=%b, full=%b, read_data=%h",
                         empty, full, read_data);
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
        $dumpvars(0,clk, read_en, rst_n, write_data, write_en, empty, full, read_data);
    end

endmodule
