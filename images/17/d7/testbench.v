`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dest_addr;
    reg [7:0] num_bytes;
    reg rst;
    reg [15:0] src_addr;
    reg start;
    wire done;
    wire read;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .num_bytes(num_bytes),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .done(done),
        .read(read),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            src_addr = 16'h0;
            dest_addr = 16'h0;
            num_bytes = 8'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Byte Transfer", test_num);
            reset_dut();

            src_addr = 16'h1000;
            dest_addr = 16'h2000;
            num_bytes = 8'd1;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            while (!done) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Byte Transfer (10 Bytes)", test_num);
            reset_dut();

            src_addr = 16'hA000;
            dest_addr = 16'hB000;
            num_bytes = 8'd10;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (100) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum Byte Transfer (255 Bytes)", test_num);
            reset_dut();

            src_addr = 16'h0000;
            dest_addr = 16'hFFFF;
            num_bytes = 8'd255;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (1024) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Consecutive Transfers", test_num);
            reset_dut();


            src_addr = 16'h1111;
            dest_addr = 16'h2222;
            num_bytes = 8'd2;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);


            @(posedge clk);
            src_addr = 16'h3333;
            dest_addr = 16'h4444;
            num_bytes = 8'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Byte Transfer", test_num);
            reset_dut();

            src_addr = 16'h1234;
            dest_addr = 16'h5678;
            num_bytes = 8'd0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (5) @(posedge clk);



            if (done == 1'b1)
                #1;

                check_outputs(1'b1, 1'b0, 1'b0);
            else
                #1;

                check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_done;
        input expected_read;
        input expected_write;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_read === (expected_read ^ read ^ expected_read) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: done=%b, read=%b, write=%b",
                         done, read, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, read=%b, write=%b",
                         expected_done, expected_read, expected_write);
                $display("  Got:      done=%b, read=%b, write=%b",
                         done, read, write);
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
        $dumpvars(0,clk, dest_addr, num_bytes, rst, src_addr, start, done, read, write);
    end

endmodule
