`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] byte_count;
    reg clk;
    reg [7:0] dest_addr;
    reg rst;
    reg [7:0] src_addr;
    reg start;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .byte_count(byte_count),
        .clk(clk),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
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
            rst = 1;
            start = 0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            byte_count = 4'd0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 1-byte transfer", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            byte_count = 4'd1;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;



            repeat (20) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8-byte transfer", test_num);
            reset_dut();

            src_addr = 8'hA0;
            dest_addr = 8'hB0;
            byte_count = 4'd8;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (30) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 15-byte transfer (Max)", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'hF0;
            byte_count = 4'hF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (50) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential transfer (Check Reset/Restart)", test_num);
            reset_dut();


            src_addr = 8'h05;
            dest_addr = 8'h0A;
            byte_count = 4'd2;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (20) begin
                if (done) break;
                @(posedge clk);
            end


            reset_dut();
            src_addr = 8'hCC;
            dest_addr = 8'hDD;
            byte_count = 4'd3;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (20) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero-byte transfer", test_num);
            reset_dut();

            src_addr = 8'h11;
            dest_addr = 8'h22;
            byte_count = 4'd0;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (10) begin
                if (done) break;
                @(posedge clk);
            end

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
        $dumpvars(0,byte_count, clk, dest_addr, rst, src_addr, start, done);
    end

endmodule
