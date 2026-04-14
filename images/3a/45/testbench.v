`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg [7:0] src_addr;
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
        .dest_addr(dest_addr),
        .src_addr(src_addr),
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
            start = 0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic transfer from 0x10 to 0x20", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            start = 1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transfer from 0xFF to 0x00", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive transfers (Back-to-back)", test_num);
            reset_dut();


            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);


            src_addr = 8'h55;
            dest_addr = 8'h66;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle state check", test_num);
            reset_dut();

            src_addr = 8'h12;
            dest_addr = 8'h34;
            start = 0;


            repeat (5) @(posedge clk);


            if (done === 1'b0) begin
                $display("PASS: Controller remained idle");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Controller started without start signal");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Same Source and Destination Address (0x88)", test_num);
            reset_dut();

            src_addr = 8'h88;
            dest_addr = 8'h88;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'h88, 1'b1);
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
        $dumpvars(0,clk, dest_addr, src_addr, start, data_out, done);
    end

endmodule
