`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] source_addr;
    reg start;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .dest_addr(dest_addr),
        .reset(reset),
        .source_addr(source_addr),
        .start(start),
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
            channel_select = 3'b0;
            source_addr = 8'h0;
            dest_addr = 8'h0;
            start = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Transfer - Channel 0", test_num);
            reset_dut();

            source_addr = 8'h10;
            dest_addr = 8'h20;
            channel_select = 3'd0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Transfer - Channel 7", test_num);
            reset_dut();

            source_addr = 8'hA5;
            dest_addr = 8'h5A;
            channel_select = 3'd7;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Transfer - Channel 3", test_num);
            reset_dut();

            source_addr = 8'hFF;
            dest_addr = 8'h00;
            channel_select = 3'd3;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Consecutive Transfers (Ch 1 then Ch 4)", test_num);
            reset_dut();


            source_addr = 8'h11;
            dest_addr = 8'h22;
            channel_select = 3'd1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(2) @(posedge clk);


            source_addr = 8'h44;
            dest_addr = 8'h88;
            channel_select = 3'd4;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle state check", test_num);
            reset_dut();

            source_addr = 8'hAA;
            dest_addr = 8'hBB;
            channel_select = 3'd2;
            start = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Transfer - Channel 5", test_num);
            reset_dut();

            source_addr = 8'hCC;
            dest_addr = 8'hDD;
            channel_select = 3'd5;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1);
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
        input expected_done;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%b",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b",
                         expected_done);
                $display("  Got:      done=%b",
                         done);
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
        $dumpvars(0,channel_select, clk, dest_addr, reset, source_addr, start, done);
    end

endmodule
