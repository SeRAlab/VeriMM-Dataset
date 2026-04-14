`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg start;
    wire [15:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
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
        addr = 0;
        data_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Transfer - 0xABCD to 0x1234", test_num);
        reset_dut();

        addr = 16'h1234;
        data_in = 16'hABCD;
        start = 1;

        @(posedge clk);
        start = 0;


        @(posedge clk);

        #1;


        check_outputs(16'hABCD, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Alternative Transfer - 0x55AA to 0xFFFF", test_num);
        reset_dut();

        addr = 16'hFFFF;
        data_in = 16'h55AA;
        start = 1;

        @(posedge clk);
        start = 0;

        @(posedge clk);

        #1;


        check_outputs(16'h55AA, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Transfer Zero Data", test_num);
        reset_dut();

        addr = 16'h0000;
        data_in = 16'h0000;
        start = 1;

        @(posedge clk);
        start = 0;

        @(posedge clk);

        #1;


        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Verify Reset Clears Operation", test_num);
        reset_dut();



        #1;




        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Sequential Transfers", test_num);
        reset_dut();


        addr = 16'h1111;
        data_in = 16'hAAAA;
        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);


        addr = 16'h2222;
        data_in = 16'hBBBB;
        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);

        #1;


        check_outputs(16'hBBBB, 1'b1);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, reset, start, data_out, done);
    end

endmodule
