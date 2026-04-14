`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] count;
    reg [15:0] dest_addr;
    reg reset;
    reg [15:0] src_addr;
    reg start;
    wire busy;
    wire done;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .count(count),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .busy(busy),
        .done(done),
        .error(error)
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
            src_addr = 16'h0;
            dest_addr = 16'h0;
            count = 8'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Normal Transfer (count=10)", test_num);
            reset_dut();

            src_addr = 16'h1000;
            dest_addr = 16'h2000;
            count = 8'd10;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (12) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Minimum Transfer (count=1)", test_num);
            reset_dut();

            src_addr = 16'hAAAA;
            dest_addr = 16'hBBBB;
            count = 8'd1;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (3) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum Transfer (count=255)", test_num);
            reset_dut();

            src_addr = 16'h0000;
            dest_addr = 16'hFFFF;
            count = 8'd255;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (260) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Interrupted Transfer (Reset mid-way)", test_num);
            reset_dut();

            src_addr = 16'h1234;
            dest_addr = 16'h5678;
            count = 8'd50;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (10) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Zero Count Edge Case", test_num);
            reset_dut();

            src_addr = 16'h1111;
            dest_addr = 16'h2222;
            count = 8'd0;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);




            if (busy === 1'b0 && (done === 1'b1 || error === 1'b1)) begin
                pass_count = pass_count + 1;
                $display("PASS: Controller handled zero count correctly (Busy: %b, Done: %b, Error: %b)", busy, done, error);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Controller in invalid state for zero count (Busy: %b, Done: %b, Error: %b)", busy, done, error);
            end
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
        input expected_error;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, error=%b",
                         busy, done, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, error=%b",
                         expected_busy, expected_done, expected_error);
                $display("  Got:      busy=%b, done=%b, error=%b",
                         busy, done, error);
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
        $dumpvars(0,clk, count, dest_addr, reset, src_addr, start, busy, done, error);
    end

endmodule
