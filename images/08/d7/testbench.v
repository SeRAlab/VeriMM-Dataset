`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dest_addr;
    reg [3:0] enable;
    reg reset;
    reg [7:0] src_addr;
    wire [15:0] data_out;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .enable(enable),
        .reset(reset),
        .src_addr(src_addr),
        .data_out(data_out),
        .transfer_done(transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 4'b0000;
            data_in = 16'h0;
            src_addr = 8'h0;
            dest_addr = 8'h0;
            repeat (2) @(posedge clk);
            reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 0 Single Transfer", test_num);
            reset_dut();

            enable = 4'b0001;
            src_addr = 8'h10;
            dest_addr = 8'h20;
            data_in = 16'hABCD;


            wait(transfer_done == 1);
            @(posedge clk);

            #1;


            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Single Transfer", test_num);
            reset_dut();

            enable = 4'b0010;
            src_addr = 8'h15;
            dest_addr = 8'h25;
            data_in = 16'h1234;

            wait(transfer_done == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 3 Single Transfer", test_num);
            reset_dut();

            enable = 4'b1000;
            src_addr = 8'hF0;
            dest_addr = 8'hFF;
            data_in = 16'hDEAD;

            wait(transfer_done == 1);
            @(posedge clk);

            #1;


            check_outputs(16'hDEAD, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-channel Transfer (CH0 Priority)", test_num);
            reset_dut();

            enable = 4'b1111;
            src_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 16'hBEEF;

            wait(transfer_done == 1);
            @(posedge clk);


            #1;



            check_outputs(16'hBEEF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            enable = 4'b0001;
            data_in = 16'h55AA;

            repeat (1) @(posedge clk);
            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;


            #1;



            check_outputs(16'h0000, 1'b0);
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
        input [15:0] expected_data_out;
        input expected_transfer_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_done=%b",
                         data_out, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_done=%b",
                         expected_data_out, expected_transfer_done);
                $display("  Got:      data_out=%h, transfer_done=%b",
                         data_out, transfer_done);
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
        $dumpvars(0,clk, data_in, dest_addr, enable, reset, src_addr, data_out, transfer_done);
    end

endmodule
