`timescale 1ns/1ps

module sync_fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg reset_n;
    reg [7:0] wr_data;
    reg wr_en;
    wire empty;
    wire full;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_fifo dut (
        .clk(clk),
        .rd_en(rd_en),
        .reset_n(reset_n),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .empty(empty),
        .full(full),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        repeat(2) @(posedge clk);
        #1 reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Write and Read", test_num);
        reset_dut();


        wr_en = 1;
        wr_data = 8'hA5;
        @(posedge clk);
        #1 wr_en = 0;


        rd_en = 1;
        @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'hA5);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill FIFO to Full", test_num);
        reset_dut();

        wr_en = 1;
        for (i = 1; i <= 8; i = i + 1) begin
            wr_data = i;
            @(posedge clk);
        end
        #1 wr_en = 0;


        #1;



        check_outputs(1'b0, 1'b1, 8'h00);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill then Empty", test_num);
        reset_dut();


        wr_en = 1;
        for (i = 1; i <= 8; i = i + 1) begin
            wr_data = i;
            @(posedge clk);
        end
        #1 wr_en = 0;


        rd_en = 1;
        repeat(8) @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'h08);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overflow Protection", test_num);
        reset_dut();


        wr_en = 1;
        for (i = 1; i <= 8; i = i + 1) begin
            wr_data = i;
            @(posedge clk);
        end


        wr_data = 8'hFF;
        @(posedge clk);
        #1 wr_en = 0;


        rd_en = 1;
        repeat(8) @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous Read and Write", test_num);
        reset_dut();


        wr_en = 1;
        wr_data = 8'h11;
        @(posedge clk);
        #1;


        wr_en = 1;
        wr_data = 8'h22;
        rd_en = 1;
        @(posedge clk);
        #1;
        wr_en = 0;
        rd_en = 0;



        #1;




        check_outputs(1'b0, 1'b0, 8'h11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Underflow Protection", test_num);
        reset_dut();


        rd_en = 1;
        repeat(3) @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'h00);
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
        input [7:0] expected_rd_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rd_data=%h",
                         expected_empty, expected_full, expected_rd_data);
                $display("  Got:      empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
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
        $dumpvars(0,clk, rd_en, reset_n, wr_data, wr_en, empty, full, rd_data);
    end

endmodule
