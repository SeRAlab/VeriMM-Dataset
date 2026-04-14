`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg reset;
    reg [31:0] wr_data;
    reg wr_en;
    wire error;
    wire not_empty;
    wire not_full;
    wire [31:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_en(rd_en),
        .reset(reset),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .error(error),
        .not_empty(not_empty),
        .not_full(not_full),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wr_en = 0;
            rd_en = 0;
            wr_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            wr_en = 1;
            wr_data = 32'hABCDE001;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Error Check", test_num);
            reset_dut();


            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, rd_data);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO to Full", test_num);
            reset_dut();

            for(i=0; i<8; i=i+1) begin
                wr_en = 1;
                wr_data = i;
                @(posedge clk);
            end
            wr_en = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, rd_data);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Error Check", test_num);
            reset_dut();


            for(i=0; i<8; i=i+1) begin
                wr_en = 1;
                wr_data = i;
                @(posedge clk);
            end


            wr_en = 1;
            wr_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1 wr_en = 0;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, rd_data);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            wr_en = 1;
            wr_data = 32'h11111111;
            @(posedge clk);


            wr_en = 1;
            wr_data = 32'h22222222;
            rd_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 32'h11111111);
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
        input expected_error;
        input expected_not_empty;
        input expected_not_full;
        input [31:0] expected_rd_data;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_not_empty === (expected_not_empty ^ not_empty ^ expected_not_empty) &&
                expected_not_full === (expected_not_full ^ not_full ^ expected_not_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: error=%b, not_empty=%b, not_full=%b, rd_data=%h",
                         error, not_empty, not_full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, not_empty=%b, not_full=%b, rd_data=%h",
                         expected_error, expected_not_empty, expected_not_full, expected_rd_data);
                $display("  Got:      error=%b, not_empty=%b, not_full=%b, rd_data=%h",
                         error, not_empty, not_full, rd_data);
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
        $dumpvars(0,clk, rd_en, reset, wr_data, wr_en, error, not_empty, not_full, rd_data);
    end

endmodule
