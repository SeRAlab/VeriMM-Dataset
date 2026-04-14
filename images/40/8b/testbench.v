`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] current_dest_addr;
    wire [7:0] current_src_addr;
    wire [7:0] dest_data;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data(data),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .current_dest_addr(current_dest_addr),
        .current_src_addr(current_src_addr),
        .dest_data(dest_data),
        .done(done)
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
            data = 8'h00;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nStarting Test Case 001: Basic single word transfer");
            reset_dut();
            test_num = test_num + 1;


            src_addr = 8'h10;
            dest_addr = 8'hA0;
            data = 8'h55;


            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);



            #1;




            check_outputs(8'hA0, 8'h10, 8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nStarting Test Case 002: Different address range and data");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 8'hFF;
            dest_addr = 8'h01;
            data = 8'hAA;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'h01, 8'hFF, 8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nStarting Test Case 003: Multiple sequential transfers");
            reset_dut();
            test_num = test_num + 1;


            src_addr = 8'h20;
            dest_addr = 8'h30;
            data = 8'h11;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);


            src_addr = 8'h40;
            dest_addr = 8'h50;
            data = 8'h22;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);


            #1;



            check_outputs(8'h50, 8'h40, 8'h22, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nStarting Test Case 004: Zero data/address transfer");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 8'h00;
            dest_addr = 8'h00;
            data = 8'h00;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nStarting Test Case 005: Boundary address check (0xFF)");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 8'hFF;
            dest_addr = 8'hFE;
            data = 8'h99;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'hFE, 8'hFF, 8'h99, 1'b1);
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
        input [7:0] expected_current_dest_addr;
        input [7:0] expected_current_src_addr;
        input [7:0] expected_dest_data;
        input expected_done;
        begin
            if (expected_current_dest_addr === (expected_current_dest_addr ^ current_dest_addr ^ expected_current_dest_addr) &&
                expected_current_src_addr === (expected_current_src_addr ^ current_src_addr ^ expected_current_src_addr) &&
                expected_dest_data === (expected_dest_data ^ dest_data ^ expected_dest_data) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_dest_addr=%h, current_src_addr=%h, dest_data=%h, done=%b",
                         current_dest_addr, current_src_addr, dest_data, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_dest_addr=%h, current_src_addr=%h, dest_data=%h, done=%b",
                         expected_current_dest_addr, expected_current_src_addr, expected_dest_data, expected_done);
                $display("  Got:      current_dest_addr=%h, current_src_addr=%h, dest_data=%h, done=%b",
                         current_dest_addr, current_src_addr, dest_data, done);
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
        $dumpvars(0,clk, data, dest_addr, reset, src_addr, start, current_dest_addr, current_src_addr, dest_data, done);
    end

endmodule
