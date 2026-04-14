`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg [7:0] dst_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire done;
    wire [15:0] mem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data(data),
        .dst_addr(dst_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .done(done),
        .mem(mem)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            start = 0;
            data = 0;
            src_addr = 0;
            dst_addr = 0;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Transfer", test_num);
            reset_dut();

            src_addr = 8'h0A;
            dst_addr = 8'h50;
            data = 16'hDEAD;
            start = 1;

            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 16'hDEAD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Different Data/Address Transfer", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dst_addr = 8'h01;
            data = 16'hBEEF;
            start = 1;

            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 16'hBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h00;
            dst_addr = 8'hFF;
            data = 16'h0000;
            start = 1;

            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h12;
            dst_addr = 8'h34;
            data = 16'hFFFF;
            start = 1;

            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No Start Issued", test_num);
            reset_dut();

            src_addr = 8'h11;
            dst_addr = 8'h22;
            data = 16'hAAAA;
            start = 0;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Transfers", test_num);
            reset_dut();


            src_addr = 8'hAA;
            dst_addr = 8'hBB;
            data = 16'h1111;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);


            src_addr = 8'hCC;
            dst_addr = 8'hDD;
            data = 16'h2222;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 16'h2222);
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
        input [15:0] expected_mem;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mem === (expected_mem ^ mem ^ expected_mem)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mem=%h",
                         done, mem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mem=%h",
                         expected_done, expected_mem);
                $display("  Got:      done=%b, mem=%h",
                         done, mem);
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
        $dumpvars(0,clk, data, dst_addr, reset, src_addr, start, done, mem);
    end

endmodule
