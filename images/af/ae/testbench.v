`timescale 1ns/1ps

module sync_fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rden;
    reg rstn;
    reg [7:0] wdata;
    reg wren;
    wire empty;
    wire full;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_fifo dut (
        .clk(clk),
        .rden(rden),
        .rstn(rstn),
        .wdata(wdata),
        .wren(wren),
        .empty(empty),
        .full(full),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            wren = 0;
            rden = 0;
            wdata = 0;
            repeat(2) @(posedge clk);
            #1 rstn = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(1, 0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write");
            reset_dut();
            @(posedge clk);
            wren <= 1;
            wdata <= 8'hAA;
            @(posedge clk);
            wren <= 0;
            #1;

            #1;


            check_outputs(0, 0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Write then Read");
            reset_dut();

            @(posedge clk);
            wren <= 1;
            wdata <= 8'h55;
            @(posedge clk);
            wren <= 0;

            @(posedge clk);
            rden <= 1;
            @(posedge clk);
            rden <= 0;
            #1;

            #1;


            check_outputs(1, 0, 8'h55);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Fill FIFO (16 elements)");
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                wren <= 1;
                wdata <= i[7:0];
            end
            @(posedge clk);
            wren <= 0;
            #1;

            #1;


            check_outputs(0, 1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Fill then Empty FIFO");
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                wren <= 1;
                wdata <= i[7:0];
            end
            @(posedge clk);
            wren <= 0;

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                rden <= 1;
            end
            @(posedge clk);
            rden <= 0;
            #1;

            #1;


            check_outputs(1, 0, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Overflow Protection (Write 17 items)");
            reset_dut();

            for (i = 0; i < 17; i = i + 1) begin
                @(posedge clk);
                wren <= 1;
                wdata <= i[7:0];
            end
            @(posedge clk);
            wren <= 0;
            #1;

            #1;


            check_outputs(0, 1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Underflow Protection (Read empty)");
            reset_dut();
            @(posedge clk);
            rden <= 1;
            repeat(2) @(posedge clk);
            rden <= 0;
            #1;

            #1;


            check_outputs(1, 0, 8'h00);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Simultaneous Read and Write");
            reset_dut();

            @(posedge clk);
            wren <= 1;
            wdata <= 8'hA1;
            @(posedge clk);

            wren <= 1;
            wdata <= 8'hB2;
            rden <= 1;
            @(posedge clk);
            wren <= 0;
            rden <= 0;
            #1;



            #1;




            check_outputs(0, 0, 8'hA1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_fifo Testbench");
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_rdata;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rdata=%h",
                         empty, full, rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rdata=%h",
                         expected_empty, expected_full, expected_rdata);
                $display("  Got:      empty=%b, full=%b, rdata=%h",
                         empty, full, rdata);
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
        $dumpvars(0,clk, rden, rstn, wdata, wren, empty, full, rdata);
    end

endmodule
