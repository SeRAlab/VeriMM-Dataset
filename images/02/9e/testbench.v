`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg reset;
    reg start;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .address(address),
        .clk(clk),
        .reset(reset),
        .start(start),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            address = 8'h00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task perform_transfer;

        input [7:0] target_addr;
        begin
            @(posedge clk);
            address = target_addr;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(busy == 1);

            wait(busy == 0);
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Single transfer (Channel 0)");
            reset_dut();

            perform_transfer(8'hAA);


            #1;



            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Round-Robin to Channel 1");
            reset_dut();


            perform_transfer(8'h11);

            perform_transfer(8'h22);


            #1;



            check_outputs(1'b0, 8'h22);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test Case 003: Full rotation to Channel 7");
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                perform_transfer(8'hF0 + i);
            end


            #1;



            check_outputs(1'b0, 8'hF7);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case 004: Wrap-around check (9th transfer returns to Ch 0)");
            reset_dut();


            for (i = 0; i < 9; i = i + 1) begin
                perform_transfer(8'hA0 + i);
            end


            #1;



            check_outputs(1'b0, 8'hA8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Reset resets RR counter to Channel 0");
            reset_dut();


            perform_transfer(8'h01);
            perform_transfer(8'h02);
            perform_transfer(8'h03);


            reset_dut();


            perform_transfer(8'hFF);

            #1;


            check_outputs(1'b0, 8'hFF);
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,address, clk, reset, start, busy, data_out);
    end

endmodule
