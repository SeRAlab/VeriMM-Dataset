`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] src_addr_chan1;
    reg [7:0] src_addr_chan2;
    reg start_chan1;
    reg start_chan2;
    wire [7:0] dest_addr_chan1;
    wire [7:0] dest_addr_chan2;
    wire transfer_complete_chan1;
    wire transfer_complete_chan2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .rst(rst),
        .src_addr_chan1(src_addr_chan1),
        .src_addr_chan2(src_addr_chan2),
        .start_chan1(start_chan1),
        .start_chan2(start_chan2),
        .dest_addr_chan1(dest_addr_chan1),
        .dest_addr_chan2(dest_addr_chan2),
        .transfer_complete_chan1(transfer_complete_chan1),
        .transfer_complete_chan2(transfer_complete_chan2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            src_addr_chan1 = 0;
            src_addr_chan2 = 0;
            start_chan1 = 0;
            start_chan2 = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic transfer on Channel 1", test_num);
            reset_dut();

            src_addr_chan1 = 8'hA5;
            start_chan1 = 1;
            @(posedge clk);
            start_chan1 = 0;


            repeat (2) @(posedge clk);


            #1;



            check_outputs(8'hA5, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic transfer on Channel 2", test_num);
            reset_dut();

            src_addr_chan2 = 8'h5A;
            start_chan2 = 1;
            @(posedge clk);
            start_chan2 = 0;

            repeat (2) @(posedge clk);


            #1;



            check_outputs(8'h00, 8'h5A, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous transfer on both channels", test_num);
            reset_dut();

            src_addr_chan1 = 8'h11;
            src_addr_chan2 = 8'hEE;
            start_chan1 = 1;
            start_chan2 = 1;
            @(posedge clk);
            start_chan1 = 0;
            start_chan2 = 0;

            repeat (2) @(posedge clk);


            #1;



            check_outputs(8'h11, 8'hEE, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify idle state (no start signal)", test_num);
            reset_dut();

            src_addr_chan1 = 8'hFF;
            src_addr_chan2 = 8'h77;
            start_chan1 = 0;
            start_chan2 = 0;

            repeat (3) @(posedge clk);


            #1;



            check_outputs(8'h00, 8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential operation Ch1 then Ch2", test_num);
            reset_dut();


            src_addr_chan1 = 8'hCC;
            start_chan1 = 1;
            @(posedge clk);
            start_chan1 = 0;
            repeat (2) @(posedge clk);


            src_addr_chan2 = 8'h33;
            start_chan2 = 1;
            @(posedge clk);
            start_chan2 = 0;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(8'hCC, 8'h33, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            src_addr_chan1 = 8'hAA;
            start_chan1 = 1;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(8'h00, 8'h00, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_dest_addr_chan1;
        input [7:0] expected_dest_addr_chan2;
        input expected_transfer_complete_chan1;
        input expected_transfer_complete_chan2;
        begin
            if (expected_dest_addr_chan1 === (expected_dest_addr_chan1 ^ dest_addr_chan1 ^ expected_dest_addr_chan1) &&
                expected_dest_addr_chan2 === (expected_dest_addr_chan2 ^ dest_addr_chan2 ^ expected_dest_addr_chan2) &&
                expected_transfer_complete_chan1 === (expected_transfer_complete_chan1 ^ transfer_complete_chan1 ^ expected_transfer_complete_chan1) &&
                expected_transfer_complete_chan2 === (expected_transfer_complete_chan2 ^ transfer_complete_chan2 ^ expected_transfer_complete_chan2)) begin
                $display("PASS");
                $display("  Outputs: dest_addr_chan1=%h, dest_addr_chan2=%h, transfer_complete_chan1=%b, transfer_complete_chan2=%b",
                         dest_addr_chan1, dest_addr_chan2, transfer_complete_chan1, transfer_complete_chan2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dest_addr_chan1=%h, dest_addr_chan2=%h, transfer_complete_chan1=%b, transfer_complete_chan2=%b",
                         expected_dest_addr_chan1, expected_dest_addr_chan2, expected_transfer_complete_chan1, expected_transfer_complete_chan2);
                $display("  Got:      dest_addr_chan1=%h, dest_addr_chan2=%h, transfer_complete_chan1=%b, transfer_complete_chan2=%b",
                         dest_addr_chan1, dest_addr_chan2, transfer_complete_chan1, transfer_complete_chan2);
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
        $dumpvars(0,clk, rst, src_addr_chan1, src_addr_chan2, start_chan1, start_chan2, dest_addr_chan1, dest_addr_chan2, transfer_complete_chan1, transfer_complete_chan2);
    end

endmodule
