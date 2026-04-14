`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .reset(reset),
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
            reset = 1;
            start = 0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic DMA Transfer", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            #10;
            start = 1;
            #10;
            start = 0;


            wait(done == 1);
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-Back Transfers", test_num);
            reset_dut();


            src_addr = 8'h11;
            dest_addr = 8'h22;
            #10;
            start = 1;
            #10;
            start = 0;
            wait(done == 1);
            #20;


            src_addr = 8'h33;
            dest_addr = 8'h44;
            #10;
            start = 1;
            #10;
            start = 0;
            wait(done == 1);
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start Signal Pulse during Operation", test_num);
            reset_dut();

            src_addr = 8'h05;
            dest_addr = 8'h0A;
            #10;
            start = 1;
            #10;
            start = 0;


            #5;
            start = 1;
            #10;
            start = 0;

            wait(done == 1);
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Different Address Ranges", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'h00;
            #10;
            start = 1;
            #10;
            start = 0;

            wait(done == 1);
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Transfer", test_num);
            reset_dut();

            src_addr = 8'hDE;
            dest_addr = 8'hAD;
            #10;
            start = 1;
            #5;
            reset = 1;
            #20;
            reset = 0;
            #10;


            src_addr = 8'hBE;
            dest_addr = 8'hEF;
            #10;
            start = 1;
            #10;
            start = 0;

            wait(done == 1);
            #10;

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
        $dumpvars(0,clk, dest_addr, reset, src_addr, start, done);
    end

endmodule
