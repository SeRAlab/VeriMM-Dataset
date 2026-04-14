`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire busy;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .busy(busy),
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
            src_addr = 0;
            dest_addr = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer Completion", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h50;
            start = 1;
            @(posedge clk);
            start = 0;



            data_in = 8'hA1; @(posedge clk);
            data_in = 8'hB2; @(posedge clk);
            data_in = 8'hC3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);


            while (!done) @(posedge clk);



            #1;




            check_outputs(1'b0, 8'hD4, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Idle State Check", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reset Mid-Transfer", test_num);
            reset_dut();

            start = 1;
            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            @(posedge clk);
            start = 0;
            data_in = 8'hFF;
            @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Consecutive Transfers", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            while(!done) @(posedge clk);

            @(posedge clk);


            start = 1;
            @(posedge clk);
            start = 0;
            data_in = 8'h55; @(posedge clk);
            data_in = 8'h66; @(posedge clk);
            data_in = 8'h77; @(posedge clk);
            data_in = 8'h88; @(posedge clk);
            while(!done) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h88, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Different Address Parameters", test_num);
            reset_dut();

            src_addr = 8'hCC;
            dest_addr = 8'hDD;
            start = 1;
            @(posedge clk);
            start = 0;

            data_in = 8'h99; @(posedge clk);
            data_in = 8'h99; @(posedge clk);
            data_in = 8'h99; @(posedge clk);
            data_in = 8'h99; @(posedge clk);

            while(!done) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h99, 1'b1);
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
        input expected_done;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, done=%b",
                         busy, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, done=%b",
                         expected_busy, expected_data_out, expected_done);
                $display("  Got:      busy=%b, data_out=%h, done=%b",
                         busy, data_out, done);
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
        $dumpvars(0,clk, data_in, dest_addr, reset, src_addr, start, busy, data_out, done);
    end

endmodule
