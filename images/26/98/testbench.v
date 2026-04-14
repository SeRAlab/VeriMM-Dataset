`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rd_en;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Post-Reset Status", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Write", test_num);
            reset_dut();

            data_in = 4'hA;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;



            #1;




            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill to Full (8 items)", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i[3:0];
                wr_en = 1;
                @(posedge clk);
                #1;
            end
            wr_en = 0;


            #1;



            check_outputs(4'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill then Empty", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i[3:0];
                @(posedge clk);
                #1;
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            rd_en = 0;


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Integrity Check", test_num);
            reset_dut();


            wr_en = 1;
            data_in = 4'h5; @(posedge clk); #1;
            data_in = 4'hE; @(posedge clk); #1;
            wr_en = 0;


            rd_en = 1; @(posedge clk); #1;
            rd_en = 0;


            #1;



            check_outputs(4'hE, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Protection", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 9; i = i + 1) begin
                data_in = i[3:0];
                @(posedge clk);
                #1;
            end
            wr_en = 0;



            #1;




            check_outputs(4'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            wr_en = 1; data_in = 4'h7; @(posedge clk); #1;
            wr_en = 0;


            wr_en = 1; data_in = 4'hB;
            rd_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;


            #1;



            check_outputs(4'hB, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pointer Wraparound", test_num);
            reset_dut();


            wr_en = 1;
            for(i=0; i<4; i=i+1) begin data_in = i; @(posedge clk); #1; end
            wr_en = 0;


            rd_en = 1;
            for(i=0; i<4; i=i+1) begin @(posedge clk); #1; end
            rd_en = 0;


            wr_en = 1;
            for(i=0; i<8; i=i+1) begin data_in = i+5; @(posedge clk); #1; end
            wr_en = 0;


            #1;



            check_outputs(4'h5, 1'b0, 1'b1);
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, data_out, empty, full);
    end

endmodule
