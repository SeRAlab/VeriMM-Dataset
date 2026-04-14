`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire busy;
    wire done;
    wire [15:0] out_data;

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
        .busy(busy),
        .done(done),
        .out_data(out_data)
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
            src_addr = 8'h0;
            dest_addr = 8'h0;
            data = 16'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Transfer (0x1234)", test_num);
            reset_dut();

            src_addr = 8'h0A;
            dest_addr = 8'h0B;
            data = 16'h1234;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1'b1);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternate Data Pattern (0xABCD)", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'h00;
            data = 16'hABCD;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h11;
            dest_addr = 8'h22;
            data = 16'h0000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Data Transfer (0xFFFF)", test_num);
            reset_dut();

            src_addr = 8'h80;
            dest_addr = 8'h81;
            data = 16'hFFFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit-Alternating Pattern (0x55AA)", test_num);
            reset_dut();

            src_addr = 8'h55;
            dest_addr = 8'hAA;
            data = 16'h55AA;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 16'h55AA);
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
        input expected_done;
        input [15:0] expected_out_data;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, out_data=%h",
                         busy, done, out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, out_data=%h",
                         expected_busy, expected_done, expected_out_data);
                $display("  Got:      busy=%b, done=%b, out_data=%h",
                         busy, done, out_data);
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
        $dumpvars(0,clk, data, dest_addr, reset, src_addr, start, busy, done, out_data);
    end

endmodule
