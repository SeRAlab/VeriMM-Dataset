`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg [7:0] num_bytes;
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
        .num_bytes(num_bytes),
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
        start <= 0;
        src_addr <= 8'h0;
        dest_addr <= 8'h0;
        num_bytes <= 8'h0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transfer 4 bytes", test_num);
        reset_dut();

        src_addr <= 8'h10;
        dest_addr <= 8'h50;
        num_bytes <= 8'd4;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;



        wait(done == 1'b1);
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transfer 1 byte", test_num);
        reset_dut();

        src_addr <= 8'hAA;
        dest_addr <= 8'hBB;
        num_bytes <= 8'd1;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;

        wait(done == 1'b1);
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transfer 16 bytes", test_num);
        reset_dut();

        src_addr <= 8'h00;
        dest_addr <= 8'h80;
        num_bytes <= 8'd16;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;

        wait(done == 1'b1);
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transfer 255 bytes", test_num);
        reset_dut();

        src_addr <= 8'h01;
        dest_addr <= 8'h02;
        num_bytes <= 8'd255;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;


        wait(done == 1'b1);
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transfer 0 bytes", test_num);
        reset_dut();

        src_addr <= 8'h11;
        dest_addr <= 8'h22;
        num_bytes <= 8'd0;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;


        repeat(5) @(posedge clk);



        #1;




        check_outputs(done);
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
        $dumpvars(0,clk, dest_addr, num_bytes, src_addr, start, done);
    end

endmodule
