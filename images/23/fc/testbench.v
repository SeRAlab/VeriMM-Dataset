`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .dout(dout),
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
            $display("\nResetting DUT...");
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            din = 8'hA5;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;


            #1 #1;
 check_outputs(8'hA5, 1, 0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill FIFO to Full", test_num);
            reset_dut();

            @(posedge clk);
            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i + 1;
                @(posedge clk);
            end
            wr_en = 0;



            #1 #1;
 check_outputs(8'h01, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Empty Status Check", test_num);
            reset_dut();


            #1 #1;
 check_outputs(8'h00, 1, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill then Empty", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 4; i = i + 1) begin
                din = 8'h10 + i;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            rd_en = 0;


            #1 #1;
 check_outputs(8'h13, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            wr_en = 1;
            din = 8'hCC;
            @(posedge clk);


            wr_en = 1;
            rd_en = 1;
            din = 8'hDD;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;


            #1 #1;
 check_outputs(8'hCC, 0, 0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Condition", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i;
                @(posedge clk);
            end


            din = 8'hFF;
            @(posedge clk);
            wr_en = 0;


            #1 #1;
 check_outputs(8'h00, 0, 1);
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, dout, empty, full);
    end

endmodule
