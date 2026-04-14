`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_address;
    reg [3:0] num_bytes;
    reg reset;
    reg [7:0] src_address;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_address(dest_address),
        .num_bytes(num_bytes),
        .reset(reset),
        .src_address(src_address),
        .start(start),
        .data_out(data_out),
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
            src_address = 0;
            dest_address = 0;
            num_bytes = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Single Byte Transfer", test_num);
            reset_dut();

            src_address = 8'h10;
            dest_address = 8'hA0;
            num_bytes = 4'd1;
            start = 1;

            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: 8-Byte Transfer", test_num);
            reset_dut();

            src_address = 8'h20;
            dest_address = 8'hB0;
            num_bytes = 4'd8;
            start = 1;

            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Maximum (15-Byte) Transfer", test_num);
            reset_dut();

            src_address = 8'h00;
            dest_address = 8'hF0;
            num_bytes = 4'hF;
            start = 1;

            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Zero Byte Transfer", test_num);
            reset_dut();

            src_address = 8'h05;
            dest_address = 8'h06;
            num_bytes = 4'd0;
            start = 1;

            @(posedge clk);
            #1 start = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Reset during operation", test_num);
            reset_dut();

            src_address = 8'h44;
            dest_address = 8'h55;
            num_bytes = 4'd10;
            start = 1;

            @(posedge clk);
            #1 start = 0;


            repeat(3) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;


            #1;



            check_outputs(data_out, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, dest_address, num_bytes, reset, src_address, start, data_out, done);
    end

endmodule
